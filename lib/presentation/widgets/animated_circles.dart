import 'package:clean_app/data/constants/ui.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class AnimatedCircles extends StatelessWidget {
  const AnimatedCircles({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  const SizedBox(
      width: 300.0,
      height: 300.0,
      child: FlareActor(
        'assets/flares/circle.flr',
        animation: "Alarm",
        color:  profileAnimatedCircles
      ),
    );
  }
}
