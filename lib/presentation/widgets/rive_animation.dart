import 'package:flutter/material.dart';
import 'package:rive/rive.dart' as rive;

class RiveAnimation extends StatelessWidget {
  const RiveAnimation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const rive.RiveAnimation.asset(
      'assets/flares/idle_breathing.riv',
      
    );
  }
}
