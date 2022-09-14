// ignore_for_file: depend_on_referenced_packages

import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:clean_app/data/constants/check_permission_status.dart';
import 'package:clean_app/data/models/location_model/clean_location.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart' as loca;
import 'package:permission_handler/permission_handler.dart';

part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit() : super(LocationInitial());

  LatLng userPosition = LatLng(29, 79);

  final loca.Location locationService = loca.Location();

  loca.LocationData? location;

  Future<void> getLocationDetails() async {
    emit(LocationLoading());

    LatLng? userPosition = await determinePosition();

    //log(userPosition.toString());

    List<Placemark> placemarks = await placemarkFromCoordinates(
        userPosition!.latitude, userPosition.longitude);

    List<Placemark> newPlacemarks = [];

    for (var placemark in placemarks) {
      if (placemark.name != '1') {
        //log(placemark.toString());
        newPlacemarks.add(placemark);
      }
    }

    //log(newPlacemarks.toString());

    var address = newPlacemarks[0].toString();

    CleanLocation cleanLocation =
        CleanLocation(address: address, coordinates: userPosition);

    emit(LocationLoaded(location: cleanLocation));

    return;
  }

  var cleanLatlng = LatLng(28, 79);

  Future<LatLng?> determinePosition() async {
    LatLng? position;

    if (locationPermission) {
      final serviceStatus = await Permission.locationWhenInUse.serviceStatus;
      final isGpsOn = serviceStatus == ServiceStatus.enabled;
      if (!isGpsOn) {
        log('TURN ON LOCATION SERVICE BEFORE REQUESTING PERMISSION.');
        emit(GPSNotOn());
        await Future.delayed(const Duration(seconds: 3));
        emit(LocationInitial());
      }
      location = await locationService.getLocation();
      //log("Actual location: ${location.toString()}");

      position = LatLng(location!.latitude!, location!.longitude!);

      userPosition = position;

      //log("userPosition location: ${location!.latitude!} ${location!.longitude!}");

      emit(UserLocationLoaded(userPosition: LatLng(location!.latitude!, location!.longitude!)));
      return position;
    }
    return position;
  }

  Future<void> getUserPosition() async {
    emit(LocationLoading());

    var location = await locationService.getLocation();

    var latlng = LatLng(location.latitude!, location.longitude!);

    emit(UserLocationLoaded(userPosition: latlng));

    userPosition = latlng;
  }
}
