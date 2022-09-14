import 'package:clean_app/data/constants/strings.dart';
import 'package:clean_app/presentation/widgets/fancy_container.dart';
import 'package:flutter/material.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({Key? key}) : super(key: key);

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  bool isSwitched = true;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned(
        left: 93,
        bottom: 70,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FancyContainer(
            height: 150,
            width: 200,
            color1: const Color.fromARGB(255, 121, 189, 244),
            color2: const Color.fromARGB(255, 242, 120, 112),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("About"),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 200,
                      child: Text(
                        "One step to make our environment clean!",
                        overflow: TextOverflow.visible,
                        softWrap: true,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      Positioned(
          left: 103,
          bottom: 2,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FancyContainer(
              height: 50,
              color1: Colors.cyan,
              color2: Colors.amber,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(madeWithLove),
                    )
                  ],
                ),
              ),
            ),
          ))
    ]);
  }
}
