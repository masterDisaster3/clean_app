// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:clean_app/data/models/marker_model/marker_model.dart';
import 'package:clean_app/logic/repositories/repository.dart';
import 'package:clean_app/presentation/widgets/location_pop_up.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';

part 'marker_state.dart';

class MarkerCubit extends Cubit<MarkerState> {
  MarkerCubit({
    required Repository repository,
  })  : _repository = repository,
        super(MarkerInitial());

  final Repository _repository;

  StreamSubscription<List<CleanMarker>>? _mapMarkerSubscription;

  List<CleanMarker> cleanMarkersFromStream = [];

  List<Marker> markersFromCleanMarkers(List<CleanMarker> cleanMarkers) {
    //log("markerCubit:markerFromCleanMarkers.cleanMakers ${cleanMarkers.toString()}");
    List<Marker> markers = [];

    for (var cMarker in cleanMarkers) {
      var tempMarker = Marker(
        point: cMarker.location,
        builder: (context) => LocationPopUp(
          cleanMarker: cMarker,
        ),
      );
      //log("markerCubit:markerFromCleanMarkers.tempMarker ${tempMarker.point.toString()}");

      markers.add(tempMarker);
    }

    //log("markerCubit:markerFromCleanMarkers.markers ${markers.toString()}");
    return markers;
  }

  Future<void> loadInitialMarkers() async {
    try {
      emit(Markerloading());

      await _repository.getMarkers();

      _mapMarkerSubscription ??= _repository.mapMarkersStream.listen((markers) {
        cleanMarkersFromStream = markers;

        //log("markerCubit:loadInitialMarkers.cleanMakers ${cleanMarkersFromStream.toString()}");

        var mapMarkers = markersFromCleanMarkers(cleanMarkersFromStream);

        //log("markerCubit:loadInitialMarkers.mapMarkers ${mapMarkers.toString()}");

        emit(Markersloaded(markersFromStream: mapMarkers));
      });
      emit(MarkersError(message: 'Error loading markers. Please refresh.'));
    } catch (e) {
      log(e.toString());
    }
  }

  saveMarker(CleanMarkerMaker cleanMarkerMaker) async {
    log("marker_cubit.saveMarker called");

    try {
      final userId = _repository.userId;
      if (userId == null) {
        throw PlatformException(
          code: 'Auth_Error',
          message: 'Session has expired',
        );
      }
      emit(MarkerUploading());
      String? imageUrl;

      final imagePath =
          '$userId/clean_app_images_${DateTime.now()}.${cleanMarkerMaker.image.path.split('.').last}';
      imageUrl = await _repository.uploadFile(
        bucket: 'markers_images',
        file: cleanMarkerMaker.image,
        path: imagePath,
      );

      await _repository.uploadMarker(CleanMarker.create(
          _repository.userId.toString(),
          imageUrl,
          cleanMarkerMaker.typeMarker,
          cleanMarkerMaker.description!,
          cleanMarkerMaker.location,
          cleanMarkerMaker.address,
          cleanMarkerMaker.createAt,
          imagePath));

      emit(MarkerUploaded());
      await Future.delayed(const Duration(seconds: 3));
      emit(MarkerInitial());
    } catch (err) {
      log("markersCubt:saveMarkers: ${err.toString()}");
      emit(MarkersError(message: "Error while uploading the data."));
      rethrow;
    }
  }

  StreamSubscription<List<CleanMarker>>? _userMarkerSubscription;

  List<CleanMarker> cleanUserMarkersFromStream = [];

  List<Marker> userMarkers = [];

  Future<void> loadOnlyUserMarkers(String userId) async {
    try {
      emit(UserMarkerloading());
      await _repository.getUserMarkers(userId);
      _userMarkerSubscription ??=
          _repository.userMarkersStream.listen((markers) {
        cleanUserMarkersFromStream = markers;

        emit(UserMarkersloaded(markersFromStream: cleanUserMarkersFromStream));
      });
      emit(MarkersError(message: 'Error loading markers. Please refresh.'));
    } catch (e) {
      log(e.toString());
    }
  }

  Future<bool> deleteMarker(String markerId, String imageUrl) async {
    emit(Markerloading());
    final res = await _repository.deleteMapMarker(markerId);

    //final resStorage = await _repository.deleteFile(bucket:"markers_images", path: imageUrl);


    if (res) {
      emit(MarkerInitial());
      return res;
    }
    return false;
  }

  refresh() async {
    await loadInitialMarkers();

    await loadOnlyUserMarkers(_repository.userId!);
  }
}
