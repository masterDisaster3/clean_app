
import 'package:flutter/material.dart';

/// Scaffold with a beautiful gradient background just for this app.
class AppScaffold extends Scaffold {
  /// Scaffold with a beautiful gradient background just for this app.
  AppScaffold({Key? key, 
    PreferredSizeWidget? appBar,
    required Widget body,
    Widget? floatingActionButton,
    Widget? bottomNavigationBar,
    bool resizeToAvoidBottomInset = true,
  }) : super(key: key, 
          appBar: appBar,
          body: Stack(
            fit: StackFit.expand,
            children: [
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromARGB(255, 130, 246, 200),
                      Color.fromARGB(255, 250, 250, 250),
                    ],
                  ),
                ),
              ),
              body,
            ],
          ),
          floatingActionButton: floatingActionButton,
          bottomNavigationBar: bottomNavigationBar,
          extendBodyBehindAppBar: true,
          resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        );
}
