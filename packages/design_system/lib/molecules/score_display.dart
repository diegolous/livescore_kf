import 'package:flutter/material.dart';

import '../tokens/tokens.dart';

/// Displays a score with per-digit odometer animation.
/// Only digits that change will roll — old digit scrolls up,
/// new digit rolls in from below.
class ScoreDisplay extends StatelessWidget {
  final int score;
  final TextStyle? style;

  const ScoreDisplay({
    super.key,
    required this.score,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final digits = '$score'.split('');

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < digits.length; i++)
          _OdometerDigit(
            key: ValueKey<int>(i - digits.length),
            digit: int.parse(digits[i]),
            style: style ?? AppTypography.scoreMedium,
          ),
      ],
    );
  }
}

class _OdometerDigit extends StatefulWidget {
  final int digit;
  final TextStyle style;

  const _OdometerDigit({
    super.key,
    required this.digit,
    required this.style,
  });

  @override
  State<_OdometerDigit> createState() => _OdometerDigitState();
}

class _OdometerDigitState extends State<_OdometerDigit>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _outSlide;
  late Animation<Offset> _inSlide;
  late Animation<double> _outFade;
  late Animation<double> _inFade;
  int _current = 0;
  int _incoming = 0;
  bool _animating = false;

  @override
  void initState() {
    super.initState();
    _current = widget.digit;
    _incoming = widget.digit;

    _controller = AnimationController(
      vsync: this,
      duration: AppDurations.normal,
    );

    _outSlide = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -1),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInCubic,
    ));

    _inSlide = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _outFade = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, AppMotion.odometerFadeOutEnd)),
    );

    _inFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(AppMotion.odometerFadeInStart, 1.0)),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _current = _incoming;
          _animating = false;
          _controller.reset();
        });
      }
    });
  }

  @override
  void didUpdateWidget(_OdometerDigit oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.digit != widget.digit) {
      _incoming = widget.digit;
      _animating = true;
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final painter = TextPainter(
      text: TextSpan(text: '0', style: widget.style),
      textDirection: TextDirection.ltr,
    )..layout();

    return SizedBox(
      width: painter.width,
      height: painter.height,
      child: ClipRect(
        child: Stack(
          alignment: Alignment.center,
          children: [
            SlideTransition(
              position: _outSlide,
              child: FadeTransition(
                opacity: _outFade,
                child: Text('$_current', style: widget.style),
              ),
            ),
            if (_animating)
              SlideTransition(
                position: _inSlide,
                child: FadeTransition(
                  opacity: _inFade,
                  child: Text('$_incoming', style: widget.style),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
