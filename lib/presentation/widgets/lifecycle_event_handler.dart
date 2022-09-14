
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LifecycleEventHandler extends WidgetsBindingObserver {
  /// Class to listen to app lifecycle such as background and foreground.
  /// Listening to app lifecycle is necessary to keep auth state.
  LifecycleEventHandler({
    required this.resumeCallBack,
  });

  /// Method to be called when the app comes back to foreground.
  final AsyncCallback resumeCallBack;

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        await resumeCallBack();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
    }
  }
}