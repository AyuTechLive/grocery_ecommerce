import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hakikat_app_new/AdminSide/testing.dart';
import 'package:hakikat_app_new/Farmers/farmers.dart';
import 'package:hakikat_app_new/Home/homepage.dart';
import 'package:hakikat_app_new/Home/mainpage.dart';
import 'package:hakikat_app_new/Splashscreen/splashscreen.dart';
import 'package:hakikat_app_new/Utils/colors.dart';
import 'package:hakikat_app_new/firebase_options.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Firebase.initializeApp(
    name: 'secondary', // Give your second app a custom name
    options: FirebaseOptions(
        apiKey: 'AIzaSyB5sOK4XWHf8YFmi1Oqp1Nsj3GqUvcuHh4',
        appId: '1:233847987701:android:5da30b41793797a4bc54bc',
        messagingSenderId: '233847987701',
        projectId: 'hakeekatfarmer',
        storageBucket: 'hakeekatfarmer.appspot.com',
        databaseURL: 'https://hakeekatfarmer-default-rtdb.firebaseio.com/'),
  );
  runApp(const MyApp());
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize('9c34ad01-1149-4c6d-8720-2afd0ea248d5');
  OneSignal.Notifications.requestPermission(true).then((value) {
    print('signal value: $value');
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Hakikat App',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a purple toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          colorScheme:
              ColorScheme.fromSeed(seedColor: AppColors.greenthemecolor),
          useMaterial3: true,
        ),
        home: SplashScreen());
  }
}
