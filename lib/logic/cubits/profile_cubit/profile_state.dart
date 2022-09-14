// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'profile_cubit.dart';

@immutable
abstract class ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final ProfileDetail profile;
  ProfileLoaded({
    required this.profile,
  });
}

class ProfileNotFound extends ProfileState{}

class ProfileError extends ProfileState{}

class ProfileLocationDetailLoaded extends ProfileState{
}
