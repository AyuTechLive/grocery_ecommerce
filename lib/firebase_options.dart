// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAHbTpwvcU5fCRSxFNAaxNblNJlmKImNJ0',
    appId: '1:460364116205:web:11c5e1a993786d81255ce4',
    messagingSenderId: '460364116205',
    projectId: 'hakkikatdemo',
    authDomain: 'hakkikatdemo.firebaseapp.com',
    databaseURL: 'https://hakkikatdemo-default-rtdb.firebaseio.com',
    storageBucket: 'hakkikatdemo.appspot.com',
    measurementId: 'G-94BYKHKR3X',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDb06naJZxObS4TAsZQeM55DNGBiAwzJHk',
    appId: '1:460364116205:android:d1af929c3a4211a7255ce4',
    messagingSenderId: '460364116205',
    projectId: 'hakkikatdemo',
    databaseURL: 'https://hakkikatdemo-default-rtdb.firebaseio.com',
    storageBucket: 'hakkikatdemo.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDY3NgP5Az2KZSQq-qdMNsvsgsFl262KtU',
    appId: '1:460364116205:ios:5fd12effb3142ced255ce4',
    messagingSenderId: '460364116205',
    projectId: 'hakkikatdemo',
    databaseURL: 'https://hakkikatdemo-default-rtdb.firebaseio.com',
    storageBucket: 'hakkikatdemo.appspot.com',
    iosBundleId: 'com.example.hakikatAppNew',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDY3NgP5Az2KZSQq-qdMNsvsgsFl262KtU',
    appId: '1:460364116205:ios:5fd12effb3142ced255ce4',
    messagingSenderId: '460364116205',
    projectId: 'hakkikatdemo',
    databaseURL: 'https://hakkikatdemo-default-rtdb.firebaseio.com',
    storageBucket: 'hakkikatdemo.appspot.com',
    iosBundleId: 'com.example.hakikatAppNew',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAHbTpwvcU5fCRSxFNAaxNblNJlmKImNJ0',
    appId: '1:460364116205:web:1cc6a311c4da305e255ce4',
    messagingSenderId: '460364116205',
    projectId: 'hakkikatdemo',
    authDomain: 'hakkikatdemo.firebaseapp.com',
    databaseURL: 'https://hakkikatdemo-default-rtdb.firebaseio.com',
    storageBucket: 'hakkikatdemo.appspot.com',
    measurementId: 'G-9GB0SPMF9E',
  );

}