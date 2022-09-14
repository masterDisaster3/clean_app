import 'package:permission_handler/permission_handler.dart';

import 'dart:developer';

bool allPermissions = false;

bool locationPermission = false;
bool cameraPermission = false;
bool storagePermission = false;

checkPermissionStatus() async {
  log("CHECK PERMISSION STATUS CALLED!");

  var locationPermissionStatus = await Permission.location.status;
  var cameraPermissionStatus = await Permission.camera.status;
  var storagePermissionStatus = await Permission.storage.status;

  if (locationPermissionStatus.isGranted) {
    locationPermission = true;
  } else if (cameraPermissionStatus.isGranted) {
    cameraPermission = true;
  } else if (storagePermissionStatus.isGranted) {
    storagePermission = true;
  }

  if (locationPermissionStatus.isLimited &&
      cameraPermissionStatus.isLimited &&
      storagePermissionStatus.isLimited) {
    log("ALL (LOCATION, CAMERA, STORAGE) PERMISSION DIDN'T ASK YET");
  } else if (locationPermissionStatus.isGranted &&
      cameraPermissionStatus.isGranted &&
      storagePermissionStatus.isGranted) {
    log("ALL (LOCATION, CAMERA, STORAGE) PERMISSION IS GRANTED!");
    allPermissions = true;
  } else if (locationPermissionStatus.isDenied) {
    log("LOCATION PERMISSION DENIED!");
  } else if (cameraPermissionStatus.isDenied) {
    log("CAMERA PERMISSION DENIED!");
  } else if (storagePermissionStatus.isDenied) {
    log("STORAGE PERMISSION DENIED!");
  } else if (locationPermissionStatus.isRestricted) {
    log("LOCATION PERMISSION RESTRICTED!");
  } else if (cameraPermissionStatus.isRestricted) {
    log("CAMERA PERMISSION RESTRICTED!");
  } else if (storagePermissionStatus.isRestricted) {
    log("STORAGE PERMISSION RESTRICTED!");
  } else if (!locationPermissionStatus.isGranted) {
    log("LOCATION PERMISSION IS NOT GRANTED!");
  } else if (!cameraPermissionStatus.isGranted) {
    log("CAMERA PERMISSION IS NOT GRANTED!");
  } else if (!storagePermissionStatus.isGranted) {
    log("STORAGE PERMISSION IS NOT GRANTED!");
  } else {
    allPermissions = false;
  }
}

requestLocationPermission() async {
  log("REQUEST LOCATION PERMISSION CALLED!");

  final status = await Permission.location.request();

  if (status == PermissionStatus.granted) {
    log('LOCATION PERMISSION GRANTED!');
    locationPermission = true;
  } else if (status == PermissionStatus.denied) {
    log('LOCATION PERMISSION DENIED!');
    // ignore: use_build_context_synchronously
  } else if (status == PermissionStatus.permanentlyDenied) {
    log('TAKE THE USER TO APP SETTINGS');
    await openAppSettings();
  }
}

requestCameraPermission() async {
  log("REQUEST CAMERA PERMISSION CALLED!");

  final status = await Permission.camera.request();
  if (status == PermissionStatus.granted) {
    log('CAMERA PERMISSION GRANTED!');

    cameraPermission = true;
  } else if (status == PermissionStatus.denied) {
    log('CAMERA PERMISSION DENIED!');
    // ignore: use_build_context_synchronously
  } else if (status == PermissionStatus.permanentlyDenied) {
    log('TAKE THE USER TO APP SETTINGS');
    await openAppSettings();
  }
}

requestStoragePermission() async {
  log("REQUEST STORAGE PERMISSION CALLED!");
  final status = await Permission.storage.request();
  if (status == PermissionStatus.granted) {
    log('Storage Permission granted.');
    storagePermission = true;
  } else if (status == PermissionStatus.denied) {
    log('Storage Permission denied.');
    // ignore: use_build_context_synchronously
  } else if (status == PermissionStatus.permanentlyDenied) {
    log('TAKE THE USER TO APP SETTINGS');
    await openAppSettings();
  }
}
