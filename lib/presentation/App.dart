// ignore_for_file: file_names

import 'package:clean_app/data/constants/check_permission_status.dart';
import 'package:clean_app/data/constants/supabase.dart';
import 'package:clean_app/data/constants/ui.dart';
import 'package:clean_app/logic/repositories/repository.dart';
import 'package:clean_app/presentation/pages/bottom_tab.dart';
import 'package:clean_app/presentation/pages/screens/permission.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase/supabase.dart';


class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  static const _supabaseUrl = SupabaseStrings.url;
  static const _supabaseannonKey = SupabaseStrings.key;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _supabaseClient =
      SupabaseClient(MyApp._supabaseUrl, MyApp._supabaseannonKey);

  final _localStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );


  _mainPage() {
    if (allPermissions == true) {
      return const BottomTab();
    } else {
      return const PermissionPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
        create: (context) => Repository(
            supabaseClient: _supabaseClient,
            localStorage: _localStorage),
        child: MaterialApp(
            title: 'Clean App',
            theme: ThemeData(
              primarySwatch: supaGreenMaterialColor,
            ),
            home: _mainPage(),
            ));
  }
}
