import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/scoreboard_bloc.dart';
import '../bloc/scoreboard_state.dart';
import '../bloc/team_logo_cubit.dart';

class SplashWrapper extends StatefulWidget {
  final Widget child;

  const SplashWrapper({super.key, required this.child});

  @override
  State<SplashWrapper> createState() => _SplashWrapperState();
}

class _SplashWrapperState extends State<SplashWrapper>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _radiusAnimation;
  late final Animation<Offset> _slideAnimation;
  bool _dismissed = false;
  bool _prefetching = false;
  bool _needsFetch = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppDurations.splash,
    );

    _radiusAnimation = Tween<double>(begin: 0.0, end: AppSpacing.splashCornerRadius).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, AppMotion.splashCornerEnd, curve: Curves.easeOutCubic),
      ),
    );

    // Phase 2 (0.55 → 1.0): slide up after a pause
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -1),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(AppMotion.splashSlideStart, 1.0, curve: Curves.easeInOutQuart),
      ),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _dismissed = true);
      }
    });

    // Dismiss splash even if server never responds
    Future.delayed(AppDurations.splashTimeout, _dismiss);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _dismiss() {
    if (mounted && !_dismissed) {
      _controller.forward();
    }
  }

  void _onStateChanged(ScoreboardState state) {
    if (_prefetching || _dismissed) return;
    if (state.matches.isEmpty) return;

    _prefetching = true;
    final logoCubit = context.read<TeamLogoCubit>();
    final teamNames = state.matches.values
        .expand((m) => [m.homeTeam, m.awayTeam])
        .toSet()
        .toList();

    final allCached = teamNames.every((t) => logoCubit.state.containsKey(t));

    if (allCached) {
      Future.delayed(AppDurations.splashHold, _dismiss);
    } else {
      setState(() => _needsFetch = true);
      logoCubit.prefetchAll(teamNames).then((_) {
        Future.delayed(AppDurations.splashHold, _dismiss);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (!_dismissed)
          BlocListener<ScoreboardBloc, ScoreboardState>(
            listener: (context, state) => _onStateChanged(state),
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return SlideTransition(
                  position: _slideAnimation,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(_radiusAnimation.value),
                      bottomRight: Radius.circular(_radiusAnimation.value),
                    ),
                    child: child,
                  ),
                );
              },
              child: _SplashContent(showLoading: _needsFetch),
            ),
          ),
      ],
    );
  }
}

class _SplashContent extends StatelessWidget {
  final bool showLoading;

  const _SplashContent({required this.showLoading});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.backgroundDark,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'LiveScore',
              style: AppTypography.splashTitle.copyWith(
                color: AppColors.white,
              ),
            ),
            const Gap.xs(),
            Text(
              'REAL-TIME SCORES',
              style: AppTypography.splashSubtitle.copyWith(
                color: AppColors.primary,
              ),
            ),
            if (showLoading) ...[
              const Gap.xxl(),
              const SizedBox(
                width: AppSpacing.xxl,
                height: AppSpacing.xxl,
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                  strokeWidth: AppBorders.timeline,
                ),
              ),
              const Gap.lg(),
              Text(
                'Loading matches...',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondaryDark,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
