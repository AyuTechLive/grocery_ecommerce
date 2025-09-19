import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hakikat_app_new/Utils/colors.dart';
import 'package:hakikat_app_new/Utils/router_config.dart';
import 'package:hakikat_app_new/firebase_options.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize('2237d8dd-271c-4501-b461-ecf2a21173f1');
  OneSignal.Notifications.requestPermission(true).then((value) {
    print('signal value: $value');
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Hakeekat App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.greenthemecolor),
        useMaterial3: true,
        fontFamily: 'GilroyBold',
      ),
      routerConfig: AppRouterConfig.createRouter(),
      debugShowCheckedModeBanner: false,
    );
  }
}
