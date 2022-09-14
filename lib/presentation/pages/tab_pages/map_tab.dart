import 'dart:math';

import 'package:clean_app/data/constants/ui.dart';
import 'package:clean_app/logic/cubits/location_cubit/location_cubit.dart';
import 'package:clean_app/logic/cubits/marker_cubit/marker_cubit.dart';
import 'package:clean_app/logic/cubits/profile_cubit/profile_cubit.dart';
import 'package:clean_app/presentation/widgets/app_scaffold.dart';
import 'package:clean_app/presentation/widgets/fancy_container.dart';
import 'package:clean_app/presentation/widgets/fetching_location.dart';
import 'package:clean_app/presentation/widgets/map_marker_details.dart';
import 'package:clean_app/presentation/widgets/profile_image.dart';
import 'package:clean_app/presentation/widgets/user_location_warning.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class MapTab2 extends StatefulWidget {
  const MapTab2({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MapTab2State createState() => _MapTab2State();
}

class _MapTab2State extends State<MapTab2> {
  LatLng? _currentPosition;

  @override
  void initState() {
    BlocProvider.of<LocationCubit>(context).getUserPosition();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationCubit, LocationState>(builder: (context, state) {
      if (state is UserLocationLoaded) {
        _currentPosition = state.userPosition;
        return CleanMap(currentUserLocation: _currentPosition, zoom: 15);
      }

      if (state is LocationLoading) {
        return const FetchingLocation(
          type: "Detecting Location..",
        );
      }

      if (state is LocationNotFound) {
        return const LocationWarning();
      }
      return CleanMap(
        currentUserLocation: LatLng(28, 79),
        zoom: 7,
      );
    });
  }
}

// ignore: must_be_immutable
class CleanMap extends StatefulWidget {
  CleanMap({Key? key, this.currentUserLocation, this.zoom}) : super(key: key);

  LatLng? currentUserLocation;

  double? zoom = 8;

  @override
  // ignore: library_private_types_in_public_api
  _CleanMapState createState() => _CleanMapState();
}

class _CleanMapState extends State<CleanMap> {
  final _placeController = TextEditingController();

  LocationData? _currentLocation;
  late final MapController _mapController;

  bool _liveUpdate = false;
  bool _permission = false;

  // ignore: unused_field
  String? _serviceError = '';

  var interActiveFlags = InteractiveFlag.all;

  final Location _locationService = Location();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    initLocationService();
  }

  void initLocationService() async {
    var userMarker = Marker(
      width: 80.0,
      height: 80.0,
      point: widget.currentUserLocation!,
      builder: (ctx) => GestureDetector(
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  var rng = Random();
                  var itsyou = rng.nextInt(5);
                  String imageGif = 'assets/images/itsyou.gif';
                  switch (itsyou) {
                    case 0: imageGif = 'assets/images/itsyou.gif';
                      break;
                       case 1: imageGif = 'assets/images/itsyou1.gif';
                      break;
                       case 2: imageGif = 'assets/images/itsyou2.gif';
                      break;
                       case 3: imageGif = 'assets/images/itsyou3.gif';
                      break;
                       case 4: imageGif = 'assets/images/itsyou4.gif';
                      break;
                       case 5: imageGif = 'assets/images/itsyou5.gif';
                      break;
                    default:
                  }

                  return AlertDialog(
                    backgroundColor: Colors.transparent,
                    scrollable: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          10.0,
                        ),
                      ),
                    ),
                    content: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(imageGif),
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                  );
                });
          },
          child: Stack(alignment: Alignment.center, children: [
            Image.asset(
              "assets/flares/pulse_dot.gif",
              scale: 25,
            ),
            BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) {
                if (state is ProfileLoaded) {
                  return ProfileImage(
                    size: 30,
                    imageUrl: state.profile.profilePictureUrl,
                  );
                }
                return Image.asset(
                  "assets/images/user.png",
                  scale: 30,
                );
              },
            )
          ])),
    );

    await _locationService.changeSettings(
      accuracy: LocationAccuracy.high,
      interval: 1000,
    );

    LocationData? location;
    bool serviceEnabled;
    bool serviceRequestResult;

    try {
      serviceEnabled = await _locationService.serviceEnabled();

      if (serviceEnabled) {
        var permission = await _locationService.requestPermission();
        _permission = permission == PermissionStatus.granted;

        if (_permission) {
          location = await _locationService.getLocation();
          _currentLocation = location;
          widget.currentUserLocation =
              LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!);
          _locationService.onLocationChanged
              .listen((LocationData result) async {
            if (mounted) {
              setState(() {
                _currentLocation = result;

                // If Live Update is enabled, move map center
                if (_liveUpdate) {
                  markers.add(userMarker);
                  _mapController.move(
                      LatLng(_currentLocation!.latitude!,
                          _currentLocation!.longitude!),
                      _mapController.zoom);
                } else {
                  markers.remove(userMarker);
                }
              });
            }
          });
        }
      } else {
        serviceRequestResult = await _locationService.requestService();
        if (serviceRequestResult) {
          initLocationService();
          return;
        }
      }
    } on PlatformException catch (e) {
      debugPrint(e.toString());
      if (e.code == 'PERMISSION_DENIED') {
        _serviceError = e.message;
      } else if (e.code == 'SERVICE_STATUS_ERROR') {
        _serviceError = e.message;
      }
      location = null;
    }
  }

  var markers = <Marker>[];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MarkerCubit, MarkerState>(builder: (context, state) {
      if (state is Markersloaded) {
        isLoading = false;
        markers = state.markersFromStream;
        //log("maptab:map.markers ${markers.toString()}");
      }

      if (state is Markerloading) {
        isLoading = true;
      }
      return AppScaffold(
        body: Stack(children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: widget.currentUserLocation,
              zoom: widget.zoom!,
              maxZoom: 19,
              interactiveFlags: interActiveFlags,
            ),
            layers: [
              TileLayerOptions(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: ['a', 'b', 'c'],
                userAgentPackageName: 'dev.fleaflet.flutter_map.example',
              ),
              MarkerLayerOptions(markers: markers),
            ],
          ),
          // Padding(
          //   padding: const EdgeInsets.fromLTRB(8, 40, 8, 8),
          //   child: TextField(
          //       controller: _placeController,
          //       decoration: InputDecoration(
          //         contentPadding: const EdgeInsets.symmetric(
          //             vertical: 15.0, horizontal: 12),
          //         fillColor: Colors.white,
          //         filled: true,
          //         border: OutlineInputBorder(
          //             borderRadius: BorderRadius.circular(30.0),
          //             borderSide: const BorderSide(width: 0.8)),
          //         enabledBorder: OutlineInputBorder(
          //             borderRadius: BorderRadius.circular(30.0),
          //             borderSide:
          //                 const BorderSide(width: 0.8, color: supaGreenColor)),
          //         hintText: "Search place",
          //         suffixIcon: IconButton(
          //             icon: const Icon(Icons.search),
          //             onPressed: () async {
          //               _placeController.clear();
          //             }),
          //       )),
          // ),
          if (isLoading) preloader
        ]),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Builder(builder: (BuildContext context) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton(
                  onPressed: () {
                    BlocProvider.of<LocationCubit>(context).determinePosition();
                    setState(() {
                      _liveUpdate = !_liveUpdate;

                      if (_liveUpdate) {
                        interActiveFlags = InteractiveFlag.drag |
                            InteractiveFlag.pinchZoom |
                            InteractiveFlag.doubleTapZoom |
                            InteractiveFlag.flingAnimation;

                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content:
                              Text('In live update mode rotation is disable'),
                        ));
                      } else {
                        interActiveFlags = InteractiveFlag.all;
                      }
                    });
                  },
                  child: _liveUpdate
                      ? const Icon(Icons.location_on)
                      : const Icon(Icons.location_off),
                ),
              );
            }),
            const MapMarkerDetails()
          ],
        ),
      );
    });
  }
}
