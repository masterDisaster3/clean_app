// ignore_for_file: use_build_context_synchronously

import 'package:animated_background/animated_background.dart';
import 'package:clean_app/data/constants/check_permission_status.dart';
import 'package:clean_app/data/constants/size.dart';
import 'package:clean_app/data/constants/strings.dart';
import 'package:clean_app/data/constants/ui.dart';
import 'package:clean_app/presentation/pages/bottom_tab.dart';
import 'package:clean_app/presentation/widgets/app_scaffold.dart';
import 'package:clean_app/presentation/widgets/fancy_container.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class PermissionPage extends StatefulWidget {
  const PermissionPage({Key? key}) : super(key: key);

  @override
  State<PermissionPage> createState() => _PermissionPageState();
}

class _PermissionPageState extends State<PermissionPage>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        body: AnimatedBackground(
      behaviour: RandomParticleBehaviour(options: locationParticles),
      vsync: this,
      child: AnimatedBackground(
        behaviour: RandomParticleBehaviour(options: cameraParticles),
        vsync: this,
        child: AnimatedBackground(
          behaviour: RandomParticleBehaviour(options: storageParticles),
          vsync: this,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/attention.png",
                height: 60,
                width: 60,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FancyContainer(
                    color1: const Color.fromARGB(255, 251, 232, 173),
                    color2: const Color.fromARGB(255, 137, 251, 234),
                    width: 350,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          permissionSection(locationPermission,
                              Iconsax.location, locationPermissonText),
                          permissionSection(cameraPermission, Iconsax.camera,
                              cameraPermissionText),
                          permissionSection(storagePermission, Iconsax.cd,
                              storagePermissionText),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor: allPermissions
                                          ? MaterialStateProperty.all(
                                              const Color.fromARGB(
                                                  255, 126, 245, 140))
                                          : MaterialStateProperty.all(
                                              const Color.fromARGB(
                                                  255, 245, 126, 126)),
                                    ),
                                    onPressed: () async {
                                      if (allPermissions) {
                                        Navigator.of(context)
                                            .pushReplacement(BottomTab.route());
                                      } else {
                                        await requestLocationPermission();
                                        setState(() {});
                                        await requestCameraPermission();
                                        setState(() {});
                                        await requestStoragePermission();

                                        setState(() {});

                                        await checkPermissionStatus();

                                        setState(() {});
                                      }

                                      // if (locationSectionColor &&
                                      //     cameraSectionColor &&
                                      //     storageSectionColor) {
                                      //   setState(() {
                                      //     BlocProvider.of<PermissionsCubit>(
                                      //             context)
                                      //         .allPermitted = true;

                                      //     if (BlocProvider.of<
                                      //             PermissionsCubit>(context)
                                      //         .allPermitted) {
                                      //       Navigator.of(context)
                                      //           .pushReplacement(
                                      //               BottomTab.route());
                                      //     }

                                      //     //allPermitted = true;
                                      //   });
                                      // }
                                    },
                                    child: const Text("Sounds Cool?"))
                              ],
                            ),
                          )
                        ],
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  Widget permissionSection(bool permitted, IconData icon, String message) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FancyContainer(
        color1: permitted
            ? const Color.fromARGB(255, 87, 128, 93)
            : const Color.fromARGB(255, 128, 87, 87),
        color2: permitted
            ? const Color.fromARGB(255, 76, 208, 96)
            : const Color.fromARGB(255, 234, 75, 75),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(
              icon,
              color: Colors.white,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                message,
                style: smallWhite,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
