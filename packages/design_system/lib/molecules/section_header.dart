import 'package:flutter/material.dart';

import '../atoms/atoms.dart';
import '../tokens/tokens.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final Color dotColor;

  const SectionHeader({
    super.key,
    required this.title,
    required this.dotColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.sectionHeaderInsets,
      child: Row(
        children: [
          StatusDot(color: dotColor),
          const Gap.sm(),
          Text(
            title,
            style: AppTypography.labelLarge.copyWith(
              color: context.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
