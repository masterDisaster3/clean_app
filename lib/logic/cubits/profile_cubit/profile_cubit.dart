// ignore: depend_on_referenced_packages
// ignore_for_file: depend_on_referenced_packages, duplicate_ignore

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:clean_app/data/models/profile_model/profile.dart';
import 'package:clean_app/data/models/profile_model/profile_detail.dart';
import 'package:clean_app/logic/repositories/repository.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({
    required Repository repository,
  })  : _repository = repository,
        super(ProfileLoading());

  final Repository _repository;
  ProfileDetail? _profile;

  // This is subscription for the stream coming from profileStreamController
  StreamSubscription<Map<String, Profile>>? _subscription;

  Future<void> loadProfile(String targetUid) async {
    log("loadProfile called");

    try {
      await _repository.getProfileDetail(targetUid);
      // it starts listening to the stream now
      _subscription = _repository.profileStream.listen((profiles) {
        _profile = profiles[targetUid];

        log("profile_cubit.loadProfile: $_subscription");

        if (_profile == null) {
          emit(ProfileNotFound());
        } else {
          emit(ProfileLoaded(profile: _profile!));
        }
      });
    } catch (err) {
      log("profile_cubit.loadProfile: ${err.toString()}");
      emit(ProfileError());
    }
  }

  Future<void> loadMyProfile() async {
    log("profile_cubit.loadMyProfile called");

    await _repository.myProfileHasLoaded.future;
    if (_repository.userId != null) {
      final uid = _repository.userId!;
      await loadProfile(uid);
    }
    return;
  }

  Future<void> loadMyProfileIfExists() async {
    log("profile_cubit.loadMyProfileIfExists called");
    final uid = _repository.userId!;
    await loadProfile(uid);
  }

  Future<void> saveProfile({
    required String name,
    required String bio,
    required File? imageFile,
  }) async {
    log("profile_cubit.saveProfile called");

    try {
      final userId = _repository.userId;
      if (userId == null) {
        throw PlatformException(
          code: 'Auth_Error',
          message: 'Session has expired',
        );
      }
      emit(ProfileLoading());
      String? imageUrl;
      if (imageFile != null) {
        final imagePath =
            '$userId/clean_app_profile_${DateTime.now()}.${imageFile.path.split('.').last}';
        imageUrl = await _repository.uploadFile(
          bucket: 'profiles',
          file: imageFile,
          path: imagePath,
        );
      }

      return _repository.saveProfile(
        profile: Profile(
          id: userId,
          name: name,
          bio: bio,
          profilePictureUrl: imageUrl,
        ),
      );
    } catch (err) {
      emit(ProfileError());
      rethrow;
    }
  }
}
