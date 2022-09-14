import 'package:clean_app/presentation/widgets/fancy_container.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

import 'app_scaffold.dart';

class LocationWarning extends StatelessWidget {
  const LocationWarning({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          SizedBox(
              width: 400,
              height: 400,
              child: RiveAnimation.asset("assets/flares/terputus.riv")),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: FancyContainer(
              color1: Color.fromARGB(255, 255, 0, 0),
              
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Flexible(
                      child: Text(
              "Your Location can't be detected! Check if the location is on or restart the application.",
              style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
            )),
                )),
          ),
        ],
      ),
    ));
  }
}
