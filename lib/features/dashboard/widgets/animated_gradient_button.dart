import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:monitoring_app/shared/constants/app_colors.dart';

class AnimatedGradientButton extends StatefulWidget {
  const AnimatedGradientButton({super.key});

  @override
  State<AnimatedGradientButton> createState() => _AnimatedGradientButtonState();
}

class _AnimatedGradientButtonState extends State<AnimatedGradientButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: SweepGradient(
              colors: const [
                Colors.red,
                Colors.green,
                Colors.blue,
                Colors.red,
              ],
              transform: GradientRotation(_controller.value * 2 * math.pi),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(2.5),
            child: Container(
              decoration: BoxDecoration(
                color: kBackgroundColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text(
                  'Event Monitoring',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
