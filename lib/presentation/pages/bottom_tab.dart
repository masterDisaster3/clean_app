import 'dart:developer';

import 'package:clean_app/data/constants/auth_required.dart';
import 'package:clean_app/data/constants/ui.dart';
import 'package:clean_app/logic/cubits/location_cubit/location_cubit.dart';
import 'package:clean_app/logic/cubits/marker_cubit/marker_cubit.dart';
import 'package:clean_app/logic/cubits/profile_cubit/profile_cubit.dart';
import 'package:clean_app/logic/repositories/repository.dart';
import 'package:clean_app/presentation/pages/tab_pages/add_tab.dart';
import 'package:clean_app/presentation/widgets/lifecycle_event_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import 'package:clean_app/data/constants/size.dart';
import 'package:clean_app/presentation/widgets/app_scaffold.dart';
import 'package:clean_app/presentation/widgets/notification_dot.dart';

import 'tab_pages/map_tab.dart';
import 'tab_pages/notificaton_tab.dart';
import 'tab_pages/profile_tab.dart';
import 'tab_pages/settings_tab.dart';

class BottomTab extends StatefulWidget {
  const BottomTab({Key? key}) : super(key: key);

  static const name = 'BottomTab';

  static Route<void> route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: name),
      builder: (_) => const BottomTab(),
    );
  }

  @override
  State<BottomTab> createState() => _BottomTabState();
}

class _BottomTabState extends State<BottomTab> {
  var currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    bool hasNewNotifications = false;
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProfileCubit>(
          create: (BuildContext context) => ProfileCubit(
            repository: RepositoryProvider.of<Repository>(context),
          )..loadMyProfile(),
        ),
        BlocProvider<LocationCubit>(
            create: (BuildContext context) =>
                LocationCubit()..determinePosition()),
        BlocProvider<MarkerCubit>(
            create: (BuildContext context) => MarkerCubit(
                repository: RepositoryProvider.of<Repository>(context))
              ..loadInitialMarkers()),
      ],
      child: AppScaffold(
        resizeToAvoidBottomInset: false,
        body: IndexedStack(
          index: currentIndex,
          children: const [
            MapTab2(),
            AddTab(isNewMarker: true),
            //const NotificationTab(),
            ProfileTab(),
            SettingsTab()
          ],
        ),
        bottomNavigationBar: Material(
          child: Padding(
            padding: EdgeInsets.only(
              top: 8,
              bottom: MediaQuery.of(context).padding.bottom + 8,
            ),
            child: Row(
              children: [
                _bottomNavigationButton(
                  label: 'Home',
                  icon: currentIndex == 0
                      ? const Icon(
                          Iconsax.home,
                          size: tabBarIconSize,
                          color: supaGreenColor,
                        )
                      : const Icon(
                          Iconsax.home,
                          size: tabBarIconSize,
                        ),
                  tabIndex: 0,
                ),
                _bottomNavigationButton(
                  label: 'Add',
                  icon: currentIndex == 1
                      ? const Icon(
                          Iconsax.add,
                          size: tabBarIconSize,
                          color: supaGreenColor,
                        )
                      : const Icon(
                          Iconsax.add,
                          size: tabBarIconSize,
                        ),
                  tabIndex: 1,
                ),
                // _bottomNavigationButton(
                //   label: 'Notifications',
                //   icon: currentIndex == 2
                //       ? const Icon(
                //           Iconsax.notification,
                //           size: tabBarIconSize,
                //           color: supaGreenColor,
                //         )
                //       : const Icon(
                //           Iconsax.notification,
                //           size: tabBarIconSize,
                //         ),
                //   tabIndex: 2,
                //   withDot: hasNewNotifications,
                //   onPressed: () {},
                // ),
                _bottomNavigationButton(
                  label: 'Profile',
                  icon: currentIndex == 2
                      ? const Icon(
                          Iconsax.personalcard,
                          size: tabBarIconSize,
                          color: supaGreenColor,
                        )
                      : const Icon(
                          Iconsax.personalcard,
                          size: tabBarIconSize,
                        ),
                  tabIndex: 2,
                ),
                _bottomNavigationButton(
                  label: 'Profile',
                  icon: currentIndex == 3
                      ? const Icon(
                          Iconsax.setting,
                          size: tabBarIconSize,
                          color: supaGreenColor,
                        )
                      : const Icon(
                          Iconsax.setting,
                          size: tabBarIconSize,
                        ),
                  tabIndex: 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomNavigationButton({
    required String label,
    required Widget icon,
    required int tabIndex,
    bool withDot = false,
    void Function()? onPressed,
  }) {
    return Expanded(
      child: InkResponse(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                SizedBox(
                  width: 30,
                  height: 30,
                  child: icon,
                ),
                if (withDot)
                  const Positioned(
                    top: -1,
                    right: -1,
                    child: NotificationDot(),
                  ),
              ],
            ),
          ],
        ),
        onTap: () async {
          //log("$tabIndex clicked");

          if (tabIndex == 1 || tabIndex == 2 || tabIndex == 3) {
            await AuthRequired.action(
              context,
              action: () {
                setState(() {
                  currentIndex = tabIndex;
                });
                if (onPressed != null) onPressed();
              },
            );
          } else {
            setState(() {
              currentIndex = tabIndex;
            });
            if (onPressed != null) onPressed();
          }
        },
      ),
    );
  }

  Future<void> onResumed() async {
    log("Onresumed called");
    await RepositoryProvider.of<Repository>(context).recoverSession();
  }

  @override
  void initState() {
    onResumed();
    WidgetsBinding.instance
        .addObserver(LifecycleEventHandler(resumeCallBack: onResumed));
    super.initState();
  }
}
