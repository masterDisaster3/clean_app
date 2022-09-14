// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:animated_background/animated_background.dart';
import 'package:clean_app/data/constants/size.dart';
import 'package:clean_app/data/constants/ui.dart';
import 'package:clean_app/data/models/marker_model/marker_model.dart';
import 'package:clean_app/data/models/profile_model/profile_detail.dart';
import 'package:clean_app/logic/cubits/marker_cubit/marker_cubit.dart';
import 'package:clean_app/logic/cubits/profile_cubit/profile_cubit.dart';
import 'package:clean_app/logic/repositories/repository.dart';
import 'package:clean_app/presentation/pages/bottom_tab.dart';
import 'package:clean_app/presentation/pages/screens/edit_profile.dart';
import 'package:clean_app/presentation/widgets/app_scaffold.dart';
import 'package:clean_app/presentation/widgets/fancy_container.dart';
import 'package:clean_app/presentation/widgets/profile_image.dart';
import 'package:clean_app/presentation/widgets/rive_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

class UserProfile extends StatefulWidget {
  const UserProfile(
      {required this.userId, required this.fromProfileTab, Key? key})
      : super(key: key);

  final String userId;
  final bool fromProfileTab;

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile>
    with TickerProviderStateMixin {
  List<CleanMarker> userMarkers = [];

  // loadClientMarker() {
  //   BlocProvider.of<MarkerCubit>(context).loadOnlyUserMarkers(
  //       RepositoryProvider.of<Repository>(context).userId!);
  // }

  @override
  void initState() {
    if (widget.fromProfileTab) {
      BlocProvider.of<MarkerCubit>(context).loadOnlyUserMarkers(
          RepositoryProvider.of<Repository>(context).userId!);
      //loadClientMarker();

    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isItMe = false;

    var me = RepositoryProvider.of<Repository>(context).userId;
    if (me == widget.userId) {
      isItMe = true;
    }

    return BlocBuilder<ProfileCubit, ProfileState>(builder: (context, state) {
      if (state is ProfileLoading) {
        return preloader;
      } else if (state is ProfileNotFound) {
        return const Text('Profile not found');
      } else if (state is ProfileLoaded) {
        final profile = state.profile;

        log("UserProfile: ${profile.toString()}");

        return AppScaffold(
          body: Container(
            decoration: const BoxDecoration(gradient: gradient2),
            child: AnimatedBackground(
              behaviour: RandomParticleBehaviour(options: particles2),
              vsync: this,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    stackedAnimationImage(profile),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FancyContainer(
                        color1: Colors.cyan,
                        color2: Colors.orange,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              if (isItMe)
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                        color: Colors.white,
                                        iconSize: 26,
                                        onPressed: () async {
                                          await Navigator.of(context).push(
                                            EditProfile.route(
                                                isCreatingAccount: false),
                                          );
                                        },
                                        icon: const Icon(Iconsax.edit)),
                                    IconButton(
                                        color: Colors.white,
                                        iconSize: 26,
                                        onPressed: signOut,
                                        icon: const Icon(Icons.logout)),
                                  ],
                                ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(profile.name,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 26,
                                        fontFamily: "Ribeye")),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Image.asset(
                                "assets/images/underline.png",
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(profile.bio!,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontFamily: "Ribeye")),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FancyContainer(
                        color1: Colors.yellow,
                        color2: Colors.indigo,
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Markers",
                                style: mediumWhite,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                stats(profile, "Locations Contributed"),
                                stats(profile, "Locations Altered"),
                              ],
                            ),
                            if (isItMe)
                              BlocBuilder<MarkerCubit, MarkerState>(
                                builder: (context, state) {
                                  if (state is UserMarkersloaded) {
                                    //log("fgtdg ${state.markersFromStream.toString()}");
                                    userMarkers = state.markersFromStream;
                                  }

                                  if (state is UserMarkerloading) {
                                    return preloader;
                                  }

                                  return GridView.count(
                                    childAspectRatio: 0.5,
                                    primary: false,
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 1.0,
                                    mainAxisSpacing: 1.0,
                                    shrinkWrap: true,
                                    children: List.generate(userMarkers.length,
                                        (index) {
                                      return markerTile(
                                          userMarkers[index], isItMe);
                                    }),
                                  );
                                },
                              ),
                            
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }

      return const Text("Somethings is wrong Report to the developer!");
    });
  }

  Widget stackedAnimationImage(ProfileDetail profile) {
    double width = 200;
    double height = 200;

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(width: width, height: height, child: const RiveAnimation()),
          ProfileImage(
            size: width / 2,
            imageUrl: profile.profilePictureUrl,
          ),
        ],
      ),
    );
  }

  Widget stats(ProfileDetail profile, String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title == "Locations Altered"
                ? profile.locationsAltered.toString()
                : profile.locationsContributed.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          Text(title,
              style: const TextStyle(color: Colors.white, fontSize: 14)),
        ],
      ),
    );
  }

  Future<void> signOut() async {
    try {
      final repository = RepositoryProvider.of<Repository>(context);
      if (repository.userId == null) {
        showGradientFlushbar(context, 'Your session has expired');
        return;
      }
      final signOutRes = await repository.signOut();

      if (signOutRes) {
        showGradientFlushbar(context, 'Your session has been signed out.');
        await Navigator.of(context).pushReplacement(
          BottomTab.route(),
        );
      }
    } catch (err) {
      log("user_profile.signOut ${err.toString()}");
      showGradientFlushbar(
        context,
        'Error occured while signing out.',
      );
    }
  }

  Widget markerTile(CleanMarker cleanMarker, bool itsMe) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: FancyContainer(
            color1: Colors.deepPurpleAccent,
            color2: const Color.fromARGB(255, 82, 235, 255),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return Column(children: [
                            AlertDialog(
                                content: Column(
                              children: [
                                Image.network(cleanMarker.imageUrl),
                                if (itsMe)
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                          color: Colors.white,
                                          iconSize: 26,
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return const AlertDialog(
                                                    content: Text(
                                                        "Here you can edit the marker."),
                                                  );
                                                });
                                          },
                                          icon: Image.asset(
                                              "assets/icons/editlocation.png")),
                                      IconButton(
                                          color: Colors.white,
                                          iconSize: 26,
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return deleteDialog(
                                                      cleanMarker.id,
                                                      cleanMarker.storageFile);
                                                });

                                            Navigator.of(context).pop();
                                          },
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ))
                                    ],
                                  ),
                              ],
                            ))
                          ]);
                        });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          cleanMarker.imageUrl,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return preloader;
                          },
                        )),
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Icon(
                            Iconsax.activity,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            width: 100,
                            child: Text(
                              cleanMarker.description!,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Icon(Iconsax.clock),
                          const SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            width: 100,
                            child: Text(
                                overflow: TextOverflow.fade,
                                softWrap: true,
                                cleanMarker.createdAt),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            )));
  }

  Widget deleteDialog(String markerId, String storageFile) {
    return AlertDialog(
      content: SizedBox(
        height: 140,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "This marker will be deleted forever!",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("cancel")),
                    IconButton(
                        onPressed: () async {
                          final res =
                              await BlocProvider.of<MarkerCubit>(context)
                                  .deleteMarker(markerId, storageFile);

                          if (res) {
                            await BlocProvider.of<MarkerCubit>(context)
                                .refresh();

                            Navigator.of(context).pop();

                            setState(() {});
                            return;
                          }
                          showGradientFlushbar(
                              context, "Error deleting marker!");
                        },
                        icon: const Icon(
                          Icons.delete_forever,
                          color: Colors.red,
                        ))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
