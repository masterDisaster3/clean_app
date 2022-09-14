// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'location_cubit.dart';

class LocationState {
  const LocationState();
}

class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}

class GetUserCurrentLocation extends LocationState {}

class GettingLocation extends LocationState {}

class LocationNotFound extends LocationState {}

class GPSNotOn extends LocationState {}

class LocationLoaded extends LocationState {
  CleanLocation location;
  LocationLoaded({
    required this.location,
  });
}

class UserLocationLoaded extends LocationState {


  LatLng userPosition;
  UserLocationLoaded({
    required this.userPosition,
  });
}