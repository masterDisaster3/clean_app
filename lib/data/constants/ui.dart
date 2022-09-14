import 'package:animated_background/particles.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

const defaultMarkerSize = 75.0;

const borderWidth = 5.0;

const appRed = Color(0xFFD73763);

const appOrange = Color(0xFFF6935C);

const appYellow = Color(0xFFDFC14F);

const appBlue = Color(0xFF3790E3);

const appLightBlue = Color(0xFF43CBE9);

const appPurple = Color(0xFF8F42A0);

const appGreen = Color.fromARGB(255, 34, 252, 209);

const buttonBackgroundColor = Color(0x33000000);

const dialogBackgroundColor = Color(0x26000000);

const yellowGreenGradient = LinearGradient(
  colors: [
    appYellow,
    appGreen,
  ],
);

Map<int, Color> supaGreenMap = {
  50: const Color.fromRGBO(101, 217, 165, .1),
  100: const Color.fromRGBO(101, 217, 165, .2),
  200: const Color.fromRGBO(101, 217, 165, .3),
  300: const Color.fromRGBO(101, 217, 165, .4),
  400: const Color.fromRGBO(101, 217, 165, .5),
  500: const Color.fromRGBO(101, 217, 165, .6),
  600: const Color.fromRGBO(101, 217, 165, .7),
  700: const Color.fromRGBO(101, 217, 165, .8),
  800: const Color.fromRGBO(101, 217, 165, .9),
  900: const Color.fromRGBO(101, 217, 165, 1)
};

MaterialColor supaGreenMaterialColor = MaterialColor(0xFF65D9A5, supaGreenMap);

const Color supaGreenColor = Color.fromRGBO(101, 217, 165, 1);

const preloader = Center(
  child: Padding(
    padding: EdgeInsets.all(8.0),
    child: SizedBox(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(supaGreenColor),
      ),
    ),
  ),
);

void showGradientFlushbar(BuildContext context, String message) {
  Flushbar(
    duration: const Duration(seconds: 3),
    margin: const EdgeInsets.all(8),
    padding: const EdgeInsets.all(10),

    backgroundGradient: const LinearGradient(
      colors: [
        supaGreenColor,
        Color.fromARGB(255, 145, 205, 250),
        Color.fromARGB(255, 150, 174, 233)
      ],
      stops: [0.4, 0.7, 1],
    ),
    boxShadows: const [
      BoxShadow(
        color: Colors.black45,
        offset: Offset(3, 3),
        blurRadius: 3,
      ),
    ],

    // All of the previous Flushbars could be dismissed
    // by swiping to any direction
    dismissDirection: FlushbarDismissDirection.HORIZONTAL,

    // The default curve is Curves.easeOut
    forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
    message: message,
    messageSize: 17,
  ).show(context);
}

ParticleOptions particles = ParticleOptions(
  image: Image.asset("assets/images/bin_marker.png"),
  baseColor: const Color.fromARGB(255, 18, 131, 218),
  spawnOpacity: 0.0,
  opacityChangeRate: 0.25,
  minOpacity: 0.1,
  maxOpacity: 0.4,
  particleCount: 20,
  spawnMaxRadius: 15.0,
  spawnMaxSpeed: 30.0,
  spawnMinSpeed: 10,
  spawnMinRadius: 7.0,
);

ParticleOptions particles2 = const ParticleOptions(
  baseColor: Color.fromARGB(255, 144, 203, 248),
  spawnOpacity: 0.0,
  opacityChangeRate: 0.25,
  minOpacity: 0.1,
  maxOpacity: 0.4,
  particleCount: 20,
  spawnMaxRadius: 15.0,
  spawnMaxSpeed: 30.0,
  spawnMinSpeed: 10,
  spawnMinRadius: 7.0,
);

ParticleOptions storageParticles = ParticleOptions(
  image: Image.asset("assets/images/file.png"),
  baseColor: const Color.fromARGB(255, 18, 131, 218),
  spawnOpacity: 0.0,
  opacityChangeRate: 0.25,
  minOpacity: 0.1,
  maxOpacity: 0.4,
  particleCount: 5,
  spawnMaxRadius: 15.0,
  spawnMaxSpeed: 30.0,
  spawnMinSpeed: 10,
  spawnMinRadius: 7.0,
);

ParticleOptions locationParticles = ParticleOptions(
  image: Image.asset("assets/images/location.png"),
  baseColor: const Color.fromARGB(255, 18, 131, 218),
  spawnOpacity: 0.0,
  opacityChangeRate: 0.25,
  minOpacity: 0.1,
  maxOpacity: 0.4,
  particleCount: 5,
  spawnMaxRadius: 15.0,
  spawnMaxSpeed: 30.0,
  spawnMinSpeed: 10,
  spawnMinRadius: 7.0,
);

ParticleOptions cameraParticles = ParticleOptions(
  image: Image.asset("assets/images/camera.png"),
  baseColor: const Color.fromARGB(255, 18, 131, 218),
  spawnOpacity: 0.0,
  opacityChangeRate: 0.25,
  minOpacity: 0.1,
  maxOpacity: 0.4,
  particleCount: 5,
  spawnMaxRadius: 15.0,
  spawnMaxSpeed: 30.0,
  spawnMinSpeed: 10,
  spawnMinRadius: 7.0,
);

const Color profileAnimatedCircles = Color.fromARGB(255, 175, 244, 140);

const gradient1 = LinearGradient(
  colors: [Color.fromARGB(255, 125, 206, 246), Color.fromARGB(255, 184, 233, 106)],
  begin: Alignment.bottomLeft,
  end: Alignment.topRight,
);

const gradient2 = LinearGradient(
  colors: [Color.fromARGB(255, 125, 246, 177), Color.fromARGB(255, 84, 160, 242)],
  begin: Alignment.bottomLeft,
  end: Alignment.topRight,
);
