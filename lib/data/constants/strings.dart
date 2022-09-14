
// ignore_for_file: depend_on_referenced_packages

import 'package:intl/intl.dart';

String madeWithLove = "Made with ❤️ in Nainital";

String locationPermissonText =
    "We require your location so that you can add your desired locations or alter them.";

String cameraPermissionText =
    "We require your camera access so that you can take beautiful images.";

String storagePermissionText =
    "We require your storage access so that we can write the session of your account.";

String currentTimeDate(DateTime dateTime) {
  String tempTime =
      DateFormat('kk:mm on EEEEEEEEEEEEEE d MMMM ${dateTime.year}')
          .format(dateTime);
  return tempTime;
}
