import 'dart:async';

import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/router/app_router.dart';
import 'core/di/injection_container.dart';
import 'features/scoreboard/domain/entities/match_event.dart';
import 'features/scoreboard/presentation/bloc/scoreboard_bloc.dart';
import 'features/scoreboard/presentation/bloc/scoreboard_event.dart';
import 'features/scoreboard/presentation/bloc/scoreboard_state.dart';
import 'features/scoreboard/presentation/bloc/team_logo_cubit.dart';
import 'features/scoreboard/presentation/pages/splash_screen.dart';
import 'features/settings/presentation/bloc/theme_cubit.dart';

void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      final prefs = await SharedPreferences.getInstance();
      initDependencies(prefs);
      runApp(LiveScoreApp(prefs: prefs));
    },
    (_, _) {},
  );
}

class LiveScoreApp extends StatelessWidget {
  final SharedPreferences prefs;

  const LiveScoreApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<ScoreboardBloc>()..add(const ScoreboardStarted()),
        ),
        BlocProvider(create: (_) => sl<TeamLogoCubit>()),
        BlocProvider(create: (_) => ThemeCubit(prefs)),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp.router(
            title: 'LiveScore',
            debugShowCheckedModeBanner: false,
            theme: LiveScoreTheme.light,
            darkTheme: LiveScoreTheme.dark,
            themeMode: themeMode,
            routerConfig: appRouter,
            builder: (context, child) {
              final isDark =
                  Theme.of(context).brightness == Brightness.dark;
              return SplashWrapper(
                child: Scaffold(
                  body: Overlay(
                    initialEntries: [
                      OverlayEntry(
                        builder: (_) => _GoalBannerScope(
                          child: child ?? const SizedBox.shrink(),
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: Colors.transparent,
                  floatingActionButton: FloatingActionButton(
                    shape: const CircleBorder(),
                    heroTag: null,
                    onPressed: () =>
                        context.read<ThemeCubit>().toggle(),
                    backgroundColor: AppColors.primary,
                    child: Icon(
                      isDark ? Icons.light_mode : Icons.dark_mode,
                      color: AppColors.backgroundDark,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _GoalBannerScope extends StatefulWidget {
  final Widget child;

  const _GoalBannerScope({required this.child});

  @override
  State<_GoalBannerScope> createState() => _GoalBannerScopeState();
}

class _GoalBannerScopeState extends State<_GoalBannerScope>
    with SingleTickerProviderStateMixin {
  OverlayEntry? _entry;
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppDurations.normal,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _removeEntry();
    _controller.dispose();
    super.dispose();
  }

  void _showBanner(GoalEvent event) {
    _removeEntry();

    _entry = OverlayEntry(
      builder: (context) {
        final topPadding = MediaQuery.of(context).padding.top;
        return Positioned(
          top: topPadding + AppSpacing.bannerTopPadding,
          left: 0,
          right: 0,
          child: SlideTransition(
            position: _slideAnimation,
            child: Padding(
              padding: AppSpacing.bannerMargin,
              child: Material(
                color: Colors.transparent,
                child: GoalBanner(
                  data: GoalBannerData(
                    team: event.team,
                    player: event.player,
                    homeScore: event.homeScore,
                    awayScore: event.awayScore,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(_entry!);
    _controller.forward(from: 0);

    Future.delayed(AppDurations.banner, () {
      if (!mounted) return;
      _controller.reverse().then((_) => _removeEntry());
    });
  }

  void _removeEntry() {
    _entry?.remove();
    _entry = null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ScoreboardBloc, ScoreboardState>(
      listenWhen: (prev, curr) =>
          curr.lastGoalEvent != null &&
          curr.lastGoalEvent != prev.lastGoalEvent,
      listener: (context, state) {
        final event = state.lastGoalEvent;
        if (event is GoalEvent) {
          _showBanner(event);
        }
      },
      child: widget.child,
    );
  }
}
