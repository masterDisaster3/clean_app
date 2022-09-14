
import 'package:clean_app/data/constants/ui.dart';
import 'package:clean_app/logic/cubits/profile_cubit/profile_cubit.dart';
import 'package:clean_app/presentation/widgets/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoaded) {
          return UserProfile(userId: state.profile.id, fromProfileTab: true);
        } else if (state is ProfileError) {
          return const Center(
            child: Text('Error loading profile'),
          );
        } else {
          return preloader;
        }
      },
    );
  }
}
