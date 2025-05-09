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
    apiKey: 'AIzaSyA1QW52QBmx09CrSbG742fQ_niXo56oL8s',
    appId: '1:715198428416:web:785fe6ec9990a7d7772fe5',
    messagingSenderId: '715198428416',
    projectId: 'yuvaapp-68669',
    authDomain: 'yuvaapp-68669.firebaseapp.com',
    storageBucket: 'yuvaapp-68669.firebasestorage.app',
    measurementId: 'G-5LGC4P5X4L',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAf4bclKuCzLEpI1V7E2VLkC_uQzIzhhCE',
    appId: '1:715198428416:android:1bbe9e05863df7bc772fe5',
    messagingSenderId: '715198428416',
    projectId: 'yuvaapp-68669',
    storageBucket: 'yuvaapp-68669.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC4FOPxYprDLk-b6jHtS701JJ_2YP8JdsQ',
    appId: '1:715198428416:ios:37db7ece1d3db1ff772fe5',
    messagingSenderId: '715198428416',
    projectId: 'yuvaapp-68669',
    storageBucket: 'yuvaapp-68669.firebasestorage.app',
    iosBundleId: 'com.example.yuva',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC4FOPxYprDLk-b6jHtS701JJ_2YP8JdsQ',
    appId: '1:715198428416:ios:37db7ece1d3db1ff772fe5',
    messagingSenderId: '715198428416',
    projectId: 'yuvaapp-68669',
    storageBucket: 'yuvaapp-68669.firebasestorage.app',
    iosBundleId: 'com.example.yuva',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyA1QW52QBmx09CrSbG742fQ_niXo56oL8s',
    appId: '1:715198428416:web:d9fa480bb08f1e33772fe5',
    messagingSenderId: '715198428416',
    projectId: 'yuvaapp-68669',
    authDomain: 'yuvaapp-68669.firebaseapp.com',
    storageBucket: 'yuvaapp-68669.firebasestorage.app',
    measurementId: 'G-S2QN3MQC46',
  );

}