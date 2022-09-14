// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'marker_cubit.dart';

class MarkerState {
  const MarkerState();
}

class MarkerInitial extends MarkerState {}

class MarkerUploading extends MarkerState {}

class MarkerUploaded extends MarkerState {}

class Markerloading extends MarkerState {}

class Markersloaded extends MarkerState {
  List<Marker> markersFromStream;
  Markersloaded({
    required this.markersFromStream,
  });
}

class UserMarkersloaded extends MarkerState {
  List<CleanMarker> markersFromStream;
  UserMarkersloaded({
    required this.markersFromStream,
  });
}

class MarkersError extends MarkerState {
  String message;
  MarkersError({
    required this.message,
  });
}


class UserMarkerloading extends MarkerState {}