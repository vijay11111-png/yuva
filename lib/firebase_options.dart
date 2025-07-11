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
    apiKey: 'AIzaSyB3lHPn3xLQHA4bCh5zMBwZj_z0vh70vZQ',
    appId: '1:112709455560:web:07ba9db19fbdd98c989ffd',
    messagingSenderId: '112709455560',
    projectId: 'theyuvaapp',
    authDomain: 'theyuvaapp.firebaseapp.com',
    storageBucket: 'theyuvaapp.firebasestorage.app',
    measurementId: 'G-695EZPMCYK',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCE2FaFqwb_o8rUlywWOiyxE-clb-HJtW8',
    appId: '1:112709455560:android:6163270a873bb940989ffd',
    messagingSenderId: '112709455560',
    projectId: 'theyuvaapp',
    storageBucket: 'theyuvaapp.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDeyGWC7KAC3lvvTg-MyC2MiPz-9PL1X4M',
    appId: '1:112709455560:ios:bb8db32e7a91fb12989ffd',
    messagingSenderId: '112709455560',
    projectId: 'theyuvaapp',
    storageBucket: 'theyuvaapp.firebasestorage.app',
    iosBundleId: 'com.example.yuva',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDeyGWC7KAC3lvvTg-MyC2MiPz-9PL1X4M',
    appId: '1:112709455560:ios:bb8db32e7a91fb12989ffd',
    messagingSenderId: '112709455560',
    projectId: 'theyuvaapp',
    storageBucket: 'theyuvaapp.firebasestorage.app',
    iosBundleId: 'com.example.yuva',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyB3lHPn3xLQHA4bCh5zMBwZj_z0vh70vZQ',
    appId: '1:112709455560:web:8478b3daa108e54b989ffd',
    messagingSenderId: '112709455560',
    projectId: 'theyuvaapp',
    authDomain: 'theyuvaapp.firebaseapp.com',
    storageBucket: 'theyuvaapp.firebasestorage.app',
    measurementId: 'G-7VM3PL5TH0',
  );
}
