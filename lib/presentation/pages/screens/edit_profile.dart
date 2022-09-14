// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:animated_background/animated_background.dart';
import 'package:clean_app/data/constants/ui.dart';
import 'package:clean_app/logic/cubits/profile_cubit/profile_cubit.dart';
import 'package:clean_app/logic/repositories/repository.dart';
import 'package:clean_app/presentation/widgets/animated_circles.dart';
import 'package:clean_app/presentation/widgets/app_scaffold.dart';
import 'package:clean_app/presentation/widgets/fancy_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key, required this.isCreatingAccount})
      : super(key: key);
  final bool isCreatingAccount;

  static const name = 'EditProfile';

  static Route<void> route({
    required bool isCreatingAccount,
  }) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: name),
      builder: (context) => BlocProvider<ProfileCubit>(
        create: (context) => ProfileCubit(
          repository: RepositoryProvider.of<Repository>(context),
        )..loadMyProfileIfExists(),
        child: EditProfile(
          isCreatingAccount: isCreatingAccount,
        ),
      ),
    );
  }

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _bioController = TextEditingController();
  String? _currentProfileImageUrl;
  File? _selectedImageFile;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        body: SafeArea(
            child: Stack(fit: StackFit.expand, children: [
      BlocConsumer<ProfileCubit, ProfileState>(listener: (context, state) {
        if (state is ProfileLoaded) {
          final profile = state.profile;

          //log("EditProfile:BlocConsumer:listener");
          //log(state.toString());
          //log(profile.toString());

          setState(() {
            _userNameController.text = profile.name;
            _bioController.text = profile.bio ?? '';
            _currentProfileImageUrl = profile.profilePictureUrl;
          });
        }
      }, builder: (context, state) {
        if (state is ProfileLoading) {
          log("EditProfile:BlocConsumer:listener");
          log(state.toString());

          return preloader;
        } else if (state is ProfileLoaded ||
            state is ProfileNotFound ||
            state is ProfileError) {
          log("EditProfile:BlocConsumer:listener");
          log(state.toString());
          return AnimatedBackground(
              behaviour: RandomParticleBehaviour(options: particles2),
              vsync: this,
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                      child: SingleChildScrollView(
                          child: FancyContainer(
                              color1: const Color.fromARGB(255, 255, 200, 35),
                              color2: const Color.fromARGB(36, 250, 0, 0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [form()]))))));
        }
        return preloader;
      }),
      Positioned(
        top: 25,
        left: 25,
        child: IconButton(
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.close),
        ),
      ),
    ])));
  }

  Widget form() {
    return Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const AnimatedCircles(),
                  ClipOval(
                    child: GestureDetector(
                      onTap: () async {
                        try {
                          final pickedImage = await ImagePicker().pickImage(
                            source: ImageSource.gallery,
                            maxWidth: 360,
                            maxHeight: 360,
                            imageQuality: 75,
                          );
                          if (pickedImage == null) {
                            return;
                          }

                          CroppedFile? croppedFile =
                              await ImageCropper().cropImage(
                            sourcePath: pickedImage.path,
                            aspectRatioPresets: [
                              CropAspectRatioPreset.square,
                              CropAspectRatioPreset.ratio3x2,
                              CropAspectRatioPreset.original,
                              CropAspectRatioPreset.ratio4x3,
                              CropAspectRatioPreset.ratio16x9
                            ],
                            uiSettings: [
                              AndroidUiSettings(
                                  toolbarTitle: 'Cropper',
                                  toolbarColor: supaGreenColor,
                                  toolbarWidgetColor: Colors.white,
                                  initAspectRatio:
                                      CropAspectRatioPreset.original,
                                  lockAspectRatio: false),
                              IOSUiSettings(
                                title: 'Cropper',
                              ),
                            ],
                          );

                          log(croppedFile!.path.toString());

                          setState(() {
                            _selectedImageFile = File(croppedFile.path);
                          });
                        } catch (e) {
                          showGradientFlushbar(
                              context, 'Error while selecting image');
                        }
                      },
                      child: SizedBox(
                        width: 200,
                        height: 200,
                        child: _profileImage(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Text("Choose a profile image!"),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _userNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "I didn't get your name..";
                  } else {
                    return null;
                  }
                },
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(
                    Iconsax.emoji_happy,
                    color: supaGreenColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24.5),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _bioController,
                maxLength: 200,
                maxLines: null,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Something about you would be perfect!";
                  } else {
                    return null;
                  }
                },
                decoration: const InputDecoration(
                  labelText: 'Bio',
                  prefixIcon: Icon(
                    Iconsax.text,
                    color: supaGreenColor,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (!widget.isCreatingAccount)
                      IconButton(
                        color: Colors.white,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.close),
                      ),
                    const SizedBox(width: 8),
                    IconButton(
                        color: Colors.white,
                        onPressed: saveProfile,
                        icon: const Icon(
                          Icons.save,
                        ))
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  void saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    try {
      final user = RepositoryProvider.of<Repository>(context).userId;
      if (user == null) {
        showGradientFlushbar(context, 'Your session has expired');
        return;
      }
      final name = _userNameController.text;
      final bio = _bioController.text;

      await BlocProvider.of<ProfileCubit>(context).saveProfile(
        name: name,
        bio: bio,
        imageFile: _selectedImageFile,
      );

      if (widget.isCreatingAccount) {
        Navigator.of(context).pop();
      } else {
        Navigator.of(context).pop();
      }
    } catch (err) {
      log("edit_profile.save_profile ${err.toString()}");
      showGradientFlushbar(
        context,
        'Error occured while saving profile',
      );
    }
  }

  Widget _profileImage() {
    if (_selectedImageFile != null) {
      return Image.file(
        _selectedImageFile!,
        fit: BoxFit.cover,
      );
    } else if (_currentProfileImageUrl != null) {
      return Image.network(
        _currentProfileImageUrl!,
        fit: BoxFit.cover,
      );
    } else {
      return Image.asset(
        'assets/images/user.png',
        fit: BoxFit.cover,
      );
    }
  }

  @override
  void initState() {
    log("Inside the Editpage");
    super.initState();
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _bioController.dispose();
    super.dispose();
  }
}
