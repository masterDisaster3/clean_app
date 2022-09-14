import 'package:clean_app/data/constants/check_permission_status.dart';
import 'package:clean_app/logic/debug/app_observer.dart';
import 'package:clean_app/presentation/App.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await checkPermissionStatus();

  BlocOverrides.runZoned(
    () => runApp(const MyApp()),
    blocObserver: AppBlocObserver(),
  );
}






/*
1. Directory creation.
  data-
    constants
    models 
  logic-
    cubits
    repositories
  presentation-
    pages
    screens
    widgets


2. Theme selection.
  1. Color : https://colorhunt.co/palette/76ba99adcf9fced89effdcae
  2. Changing themes according to system and dedicated theme button.

gif:  https://tenor.com/view/the-office-dwight-schrute-rainn-wilson-type-typing-gif-4468294

icon: "https://icons8.com/icon/AlgMnoDkTbLD/path"

3. User registration using Supabase authentication.

4. Creation of users table:
  Columns-
    id
    name
    bio
    profile_picture_url

5. Saving the data to the users table.


TODO - add Tab Bar instead

TODO - noification

TODO - Search places

TODO future implimentation : user can add multiple images of location.


TODO = Network cubit

TODO - Theme Bloc

TODO -  operation for markers

C Creation done
R Read done
U Update
D Delete done


TODO - Get direction button

TODO -  avatar Profile picture dragabble in edit profile

Location contributed in profile tab

Detect location map tab


TODO = delete files from storage


*/



