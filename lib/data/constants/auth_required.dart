// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:clean_app/logic/repositories/repository.dart';
import 'package:clean_app/presentation/pages/screens/edit_profile.dart';
import 'package:clean_app/presentation/pages/screens/registration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthRequired {
  static Future<void> action(
    BuildContext context, {
    required void Function() action,
  }) async {
    final repository = RepositoryProvider.of<Repository>(context);
    await repository.statusKnown.future;

    final userId = repository.userId;

    log("AuthRequired.action.User id : $userId");

    if (userId == null) {
      await Navigator.of(context).push(Registration.route());
      return;
    }
    final myProfile = repository.myProfile;

    log("AuthRequired.action.Profile: ${myProfile?.id}");

    myProfile == null;
    if (myProfile == null) {
      await Navigator.of(context)
          .push(EditProfile.route(isCreatingAccount: true));
    } else {
      action();
    }
  }
}
