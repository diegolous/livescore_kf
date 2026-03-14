import 'package:flutter/material.dart';

import '../tokens/tokens.dart';

class Gap extends StatelessWidget {
  final double size;

  const Gap(this.size, {super.key});

  const Gap.xxs({super.key}) : size = AppSpacing.xxs;
  const Gap.xs({super.key}) : size = AppSpacing.xs;
  const Gap.sm({super.key}) : size = AppSpacing.sm;
  const Gap.md({super.key}) : size = AppSpacing.md;
  const Gap.lg({super.key}) : size = AppSpacing.lg;
  const Gap.xl({super.key}) : size = AppSpacing.xl;
  const Gap.xxl({super.key}) : size = AppSpacing.xxl;

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: size, height: size);
  }
}
