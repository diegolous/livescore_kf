import 'package:flutter/material.dart';

import '../tokens/tokens.dart';

class PillBadge extends StatelessWidget {
  final String label;
  final Color foregroundColor;
  final Color backgroundColor;
  final Color? borderColor;
  final Widget? leading;
  final EdgeInsetsGeometry? padding;

  const PillBadge({
    super.key,
    required this.label,
    required this.foregroundColor,
    required this.backgroundColor,
    this.borderColor,
    this.leading,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ??
          const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xxs,
          ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: AppRadii.fullBorder,
        border: borderColor != null
            ? Border.all(color: borderColor!, width: AppBorders.regular)
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(width: AppSpacing.xs),
          ],
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(color: foregroundColor),
          ),
        ],
      ),
    );
  }
}
