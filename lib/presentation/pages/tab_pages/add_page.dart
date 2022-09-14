// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:clean_app/data/constants/size.dart';
import 'package:clean_app/data/constants/strings.dart';
import 'package:clean_app/data/constants/ui.dart';
import 'package:clean_app/data/models/location_model/clean_location.dart';
import 'package:clean_app/data/models/marker_model/marker_model.dart';
import 'package:clean_app/logic/cubits/location_cubit/location_cubit.dart';
import 'package:clean_app/logic/cubits/marker_cubit/marker_cubit.dart';
import 'package:clean_app/logic/cubits/profile_cubit/profile_cubit.dart';
import 'package:clean_app/logic/repositories/repository.dart';
import 'package:clean_app/presentation/widgets/fancy_container.dart';
import 'package:clean_app/presentation/widgets/profile_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';

class AddPage extends StatefulWidget {
  AddPage({super.key, required this.isNewMarker});

  bool isNewMarker;

  static const name = 'AddTab';

  Route<void> route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: name),
      builder: (_) => AddPage(
        isNewMarker: isNewMarker,
      ),
    );
  }

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final _formKey = GlobalKey<FormState>();

  String dropdownvalue = 'Trash';
  var items = ["Trash", "Dustbin"];

  File? _selectedImageFile;

  LatLng? location;

  bool haveImage = false;

  String? address;

  final locationController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 50, 8, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/flares/location-red.gif",
                  width: 50,
                  height: 50,
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FancyContainer(
              color1: const Color.fromARGB(255, 103, 163, 241),
              color2: const Color.fromARGB(255, 133, 172, 255),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: locationController,
                                  maxLines: null,
                                  decoration: const InputDecoration(
                                    labelText: 'Location',
                                    prefixIcon: Icon(
                                      Iconsax.location,
                                      color: supaGreenColor,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Location can't be empty";
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ),
                              BlocBuilder<LocationCubit, LocationState>(
                                  builder: (context, state) {
                                if (state is LocationLoading) {
                                  return preloader;
                                } else if (state is GPSNotOn) {
                                  return warningForGPS();
                                } else if (state is LocationLoaded) {
                                  CleanLocation markerLocation = state.location;
                                  location = LatLng(
                                      markerLocation.coordinates!.latitude,
                                      markerLocation.coordinates!.longitude);

                                  //log("addTab.build. locationLoaded. ${markerLocation.toString()}");

                                  address = markerLocation.toString();
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                Iconsax.check,
                                                size: 18,
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              const Text(
                                                "You can add more relevant details too",
                                                style: TextStyle(fontSize: 14),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: IconButton(
                                                    onPressed: () async {
                                                      BlocProvider.of<
                                                                  LocationCubit>(
                                                              context)
                                                          .getLocationDetails();

                                                      //log("This is the address: ${address!}");

                                                      locationController.text =
                                                          address!;
                                                    },
                                                    icon: const Icon(
                                                        Iconsax.refresh)),
                                              )
                                            ],
                                          )),
                                    ],
                                  );
                                }

                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ElevatedButton(
                                          onPressed: () async {
                                            BlocProvider.of<LocationCubit>(
                                                    context)
                                                .getLocationDetails();
                                          },
                                          child:
                                              const Text("Detect Location?")),
                                    ),
                                  ],
                                );
                              }),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: descriptionController,
                                  maxLines: null,
                                  decoration: const InputDecoration(
                                    labelText: 'Description',
                                    prefixIcon: Icon(
                                      Iconsax.text,
                                      color: supaGreenColor,
                                    ),
                                  ),
                                ),
                              ),
                              FancyContainer(
                                color1: Colors.tealAccent,
                                color2: Colors.yellow,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                          height: 250,
                                          child: haveImage
                                              ? ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  child: Image.file(
                                                      _selectedImageFile!),
                                                )
                                              : Image.asset(
                                                  "assets/images/no_image.png",
                                                  height: 200,
                                                  width: 200,
                                                )),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          IconButton(
                                              onPressed: () async {
                                                try {
                                                  final pickedImage =
                                                      await ImagePicker()
                                                          .pickImage(
                                                    maxHeight: 2000,
                                                    maxWidth: 1000,
                                                    source: ImageSource.camera,
                                                  );
                                                  if (pickedImage == null) {
                                                    return;
                                                  }
                                                  setState(() {
                                                    _selectedImageFile =
                                                        File(pickedImage.path);
                                                    haveImage = true;
                                                  });
                                                } catch (e) {
                                                  showGradientFlushbar(context,
                                                      'Error while selecting image');
                                                }
                                              },
                                              icon: const Icon(
                                                Icons.add_a_photo_outlined,
                                                size: 30,
                                              )),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Type of marker : ",
                                    style: mediumAddBlack,
                                  ),
                                  const SizedBox(width: 20),
                                  DropdownButton(
                                    dropdownColor: supaGreenColor,
                                    value: dropdownvalue,
                                    icon: const Icon(Icons.keyboard_arrow_down),
                                    items: items.map((String items) {
                                      return DropdownMenuItem(
                                          value: items,
                                          child: Text(
                                            items,
                                            style: smallBlack,
                                          ));
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        dropdownvalue = newValue!;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              BlocBuilder<ProfileCubit, ProfileState>(
                                builder: (context, state) {
                                  if (state is ProfileLoaded) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            widget.isNewMarker
                                                ? "Contribution of: "
                                                : "Alteration  by: ",
                                            style: mediumAddBlack,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Flexible(
                                            child: Text(
                                              state.profile.name,
                                              style: const TextStyle(
                                                  fontSize: 20.0,
                                                  fontFamily: "Ribeye"),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          ProfileImage(
                                            imageUrl:
                                                state.profile.profilePictureUrl,
                                          )
                                        ],
                                      ),
                                    );
                                  }
                                  return const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      "Error loading profile, you have signed in right?",
                                      style: smallBlack,
                                    ),
                                  );
                                },
                              ),
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Iconsax.clock,
                                        color: supaGreenColor,
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Flexible(
                                        child: Text(
                                          currentTimeDate(DateTime.now()),
                                          style: mediumAddBlack,
                                        ),
                                      )
                                    ],
                                  )),
                              BlocBuilder<MarkerCubit, MarkerState>(
                                  builder: (context, state) {
                                {
                                  if (state is MarkerUploading) {
                                    return preloader;
                                  } else if (state is MarkerUploaded) {
                                    return Image.asset(
                                      "assets/flares/confetti.gif",
                                      width: 80,
                                      height: 80,
                                    );
                                  }

                                  return ElevatedButton(
                                      onPressed: addMarker,
                                      child: const Text("Good to go?"));
                                }
                              })
                            ]),
                      ],
                    )),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget box(String title, Color backgroundcolor) {
    return Container(
        margin: const EdgeInsets.all(10),
        width: 80,
        color: backgroundcolor,
        alignment: Alignment.center,
        child: Text(title,
            style: const TextStyle(color: Colors.white, fontSize: 20)));
  }

  Widget warningForGPS() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Iconsax.warning_2),
          SizedBox(
            width: 10,
          ),
          Text(
            "Kindly turn on the GPS",
            style: smallBlack,
          ),
        ],
      ),
    );
  }

  addMarker() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    try {
      final user = RepositoryProvider.of<Repository>(context).userId;
      if (user == null) {
        showGradientFlushbar(context, 'Your session has expired');
        return;
      }

      //log(currentTimeDate(DateTime.now()));

      await BlocProvider.of<MarkerCubit>(context).saveMarker(CleanMarkerMaker(
          userId: user,
          image: _selectedImageFile!,
          typeMarker: dropdownvalue,
          location: location!,
          address: locationController.text,
          description: descriptionController.text,
          createAt: currentTimeDate(DateTime.now())));

      descriptionController.clear();
      locationController.clear();
      setState(() {
        haveImage = false;
      });

      await BlocProvider.of<MarkerCubit>(context).refresh();
    } catch (err) {
      log("addTab:addMaker ${err.toString()}");
      showGradientFlushbar(
        context,
        'Error occured while saving marker.',
      );
    }
  }

  @override
  void dispose() {
    descriptionController.dispose();
    locationController.dispose();
    super.dispose();
  }
}
