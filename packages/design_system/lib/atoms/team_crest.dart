import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../tokens/tokens.dart';

class TeamCrest extends StatelessWidget {
  final String teamName;
  final String? badgeUrl;
  final double size;
  final BoxShape shape;

  const TeamCrest({
    super.key,
    required this.teamName,
    this.badgeUrl,
    this.size = AppSpacing.crestDefault,
    this.shape = BoxShape.circle,
  });

  const TeamCrest.large({
    super.key,
    required this.teamName,
    this.badgeUrl,
  })  : size = AppSpacing.crestLarge,
        shape = BoxShape.rectangle;

  @override
  Widget build(BuildContext context) {
    final borderRadius = shape == BoxShape.rectangle ? AppRadii.xlBorder : null;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: badgeUrl != null ? AppColors.backgroundDark : AppColors.overlay,
        shape: shape,
        borderRadius: borderRadius,
        border: Border.all(color: context.border, width: AppBorders.regular),
      ),
      clipBehavior: Clip.antiAlias,
      child: badgeUrl != null
          ? Padding(
              padding: const EdgeInsets.all(AppSpacing.xs),
              child: CachedNetworkImage(
                imageUrl: badgeUrl!,
                fit: BoxFit.contain,
                fadeInDuration: AppDurations.fast,
                placeholder: (_, _) => _ShimmerPlaceholder(size: size),
                errorWidget: (_, _, _) => _Placeholder(teamName: teamName),
              ),
            )
          : _Placeholder(teamName: teamName),
    );
  }
}

class _ShimmerPlaceholder extends StatefulWidget {
  final double size;

  const _ShimmerPlaceholder({required this.size});

  @override
  State<_ShimmerPlaceholder> createState() => _ShimmerPlaceholderState();
}

class _ShimmerPlaceholderState extends State<_ShimmerPlaceholder>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppDurations.pulse,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: AppMotion.shimmerOpacityMin, end: AppMotion.shimmerOpacityMax).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: _animation.value),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
}

class _Placeholder extends StatelessWidget {
  final String teamName;

  const _Placeholder({required this.teamName});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        teamName.isNotEmpty ? teamName.substring(0, 1).toUpperCase() : '?',
        style: AppTypography.titleLarge.copyWith(
          color: context.textSecondary,
        ),
      ),
    );
  }
}
