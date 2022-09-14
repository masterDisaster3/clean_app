import 'package:clean_app/data/constants/auth_required.dart';
import 'package:clean_app/data/constants/ui.dart';
import 'package:clean_app/data/models/marker_model/marker_model.dart';
import 'package:clean_app/logic/cubits/profile_cubit/profile_cubit.dart';
import 'package:clean_app/logic/repositories/repository.dart';
import 'package:clean_app/presentation/pages/screens/profile_page.dart';
import 'package:clean_app/presentation/widgets/fancy_container.dart';
import 'package:clean_app/presentation/widgets/profile_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

class LocationPopUp extends StatelessWidget {
  const LocationPopUp({
    Key? key,
    required this.cleanMarker,
  }) : super(key: key);

  final CleanMarker cleanMarker;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          await showDialog(
              context: context,
              builder: (BuildContext context) {
                return BlocProvider(
                  create: (context) => ProfileCubit(
                    repository: RepositoryProvider.of<Repository>(context),
                  )..loadProfile(cleanMarker.userId),
                  child: AlertDialog(
                      backgroundColor: Colors.transparent,
                      scrollable: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            10.0,
                          ),
                        ),
                      ),
                      contentPadding: const EdgeInsets.all(
                        8.0,
                      ),
                      content: FancyContainer(
                          color1: Colors.amber,
                          color2: const Color.fromARGB(255, 100, 146, 255),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(children: <Widget>[
                              BlocBuilder<ProfileCubit, ProfileState>(
                                  builder: (context, state) {
                                if (state is ProfileLoading) {
                                  return preloader;
                                }

                                if (state is ProfileLoaded) {
                                  return locationDetail(
                                      Iconsax.info_circle,
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                              width: 100,
                                              child: Text(
                                                overflow: TextOverflow.visible,
                                                softWrap: true,
                                                state.profile.name,
                                                style: const TextStyle(
                                                    fontSize: 20.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              await Navigator.of(context)
                    .push(ProfilePage.route(state.profile.id));
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: ProfileImage(
                                                  imageUrl: state.profile
                                                              .profilePictureUrl ==
                                                          null
                                                      ? null
                                                      : state.profile
                                                          .profilePictureUrl!),
                                            ),
                                          ),
                                        ],
                                      ));
                                }

                                return locationDetail(Iconsax.info_circle,
                                    const Text("No Profile details found!"));
                              }),
                              locationDetail(
                                  Iconsax.image,
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.network(
                                        cleanMarker.imageUrl,
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          }
                                          return preloader;
                                        },
                                      ))),
                              locationDetail(
                                  Iconsax.activity,
                                  Text(cleanMarker.description == null
                                      ? "No description"
                                      : cleanMarker.description!)),
                              locationDetail(
                                  Iconsax.location, Text(cleanMarker.address)),
                              locationDetail(
                                  Iconsax.clock, Text(cleanMarker.createdAt)),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  // IconButton(
                                  //   onPressed: () {
                                  //     AuthRequired.action(context,
                                  //         action: () {});

                                  //     //Navigator.of(context).push(
                                  //     //AddTab(isNewMarker: false).route());

                                  //     Navigator.of(context).pop();
                                  //   },
                                  //   icon: const Icon(Iconsax.edit),
                                  // ),
                                  IconButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    icon: const Icon(Icons.close),
                                  ),
                                ],
                              ),
                            ]),
                          ))),
                );
              });
        },
        child: cleanMarker.typeMarker == "Trash"
            ? Image.asset(
                "assets/icons/dumped_trash.png",
                height: 10,
                width: 10,
                scale: 12,
              )
            : Image.asset(
                "assets/icons/dustbin.png",
                height: 10,
                width: 10,
                scale: 12,
              ));
  }

  Widget locationDetail(IconData? icon, Widget detail) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(
            width: 10,
          ),
          Flexible(child: detail)
        ],
      ),
    );
  }
}



// SizedBox(
//                                 width: 200,
//                                 child: BlocBuilder<ProfileCubit, ProfileState>(
//                                     builder: (context, state) {
//                                   if (state is ProfileLoading) {
//                                     return preloader;
//                                   }

//                                   if (state is ProfileLoaded) {
//                                     return locationDetail(
//                                         Iconsax.info_circle,
//                                         Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.center,
//                                           children: [
//                                             Padding(
//                                               padding: const EdgeInsets.all(8.0),
//                                               child: SizedBox(
//                                                 width: 70,
//                                                 child: Flexible(
//                                                   child: Text(
//                                                     state.profile.name,
//                                                     style: const TextStyle(
//                                                         fontSize: 20.0,
//                                                         fontWeight:
//                                                             FontWeight.bold),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                             Padding(
//                                               padding: const EdgeInsets.all(8.0),
//                                               child: ProfileImage(
//                                                   imageUrl: state.profile
//                                                       .profilePictureUrl!),
//                                             ),
//                                           ],
//                                         ));
//                                   }

//                                   return const Text("Error loading Profile");
//                                 }),
//                               ),