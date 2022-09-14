import 'package:flutter/material.dart';


class MapMarkerDetails extends StatelessWidget {
  const MapMarkerDetails({Key? key}) : super(key: key);

  @override
  Widget 
    build(BuildContext context) {
    return Container(
      width: 150,
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 193, 186, 186).withOpacity(0.5),
          borderRadius: BorderRadius.circular(10)),
      child: Center(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Image.asset(
                  "assets/icons/dumped_trash.png",
                  height: 30,
                  width: 30,
                ),
                const Text(": Dumped trash")
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Row(
              children: [
                Image.asset(
                  "assets/icons/dustbin.png",
                  height: 30,
                  width: 30,
                ),
                const Text(": Dustbin")
              ],
            ),
          ),
          
        ],
      )),
    );
  }
}