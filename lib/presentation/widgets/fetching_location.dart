import 'package:clean_app/data/constants/size.dart';
import 'package:clean_app/presentation/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart' as rive;

class FetchingLocation extends StatelessWidget {
  const FetchingLocation({Key? key, required this.type}) : super(key: key);

  final String type;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body:  Center(
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const SizedBox(
              width: 400,height: 400,
              child: rive.RiveAnimation.asset(
                'assets/flares/fetching_location.riv',
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(type, style: mediumBlack,),
            )
          ],
        ),
      ),
    );
  }
}
