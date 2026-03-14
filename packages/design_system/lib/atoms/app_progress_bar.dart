import 'package:flutter/material.dart';

import '../tokens/tokens.dart';

class AppProgressBar extends StatelessWidget {
  final double value;
  final Color activeColor;
  final Color trackColor;
  final double height;

  const AppProgressBar({
    super.key,
    required this.value,
    required this.activeColor,
    this.trackColor = AppColors.progressTrack,
    this.height = AppSpacing.progressBarHeight,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppRadii.fullBorder,
      child: SizedBox(
        height: height,
        child: LinearProgressIndicator(
          value: value.clamp(0.0, 1.0),
          backgroundColor: trackColor,
          valueColor: AlwaysStoppedAnimation<Color>(activeColor),
          minHeight: height,
        ),
      ),
    );
  }
}
