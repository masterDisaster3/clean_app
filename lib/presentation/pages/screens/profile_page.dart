import 'package:clean_app/logic/cubits/marker_cubit/marker_cubit.dart';
import 'package:clean_app/presentation/widgets/app_scaffold.dart';
import 'package:clean_app/presentation/widgets/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../logic/cubits/profile_cubit/profile_cubit.dart';
import '../../../logic/repositories/repository.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key, required this.userId}) : super(key: key);

  static const name = 'ProfilePage';

  final String userId;

  /// Method ot create this page with necessary `BlocProvider`
  static Route<void> route(String userId) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: name),
      builder: (_) => BlocProvider<ProfileCubit>(
        create: (context) => ProfileCubit(
          repository: RepositoryProvider.of<Repository>(context),
        )..loadProfile(userId),
        child: ProfilePage(userId: userId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text(
            "Fellow user",
            style: TextStyle(color: Colors.white),
          )),
      body:  UserProfile(
          userId: userId,
          fromProfileTab: false,
        ),
    );
  }
}
