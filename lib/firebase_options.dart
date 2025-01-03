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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDJl4yv4239rE0wEt2FeTUE0-hsvVfggK0',
    appId: '1:172326065824:android:37f35633d5d9b4a39d1bc5',
    messagingSenderId: '172326065824',
    projectId: 'bdnew-1e932',
    storageBucket: 'bdnew-1e932.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBq_4usE1m6u4_5--9IOhAkZ9y2ad9BR5k',
    appId: '1:172326065824:ios:e8b3ca46b5b2fe5b9d1bc5',
    messagingSenderId: '172326065824',
    projectId: 'bdnew-1e932',
    storageBucket: 'bdnew-1e932.firebasestorage.app',
    androidClientId: '172326065824-ftt0cj0u4sc5k8jhard5fqqknrnaplrf.apps.googleusercontent.com',
    iosClientId: '172326065824-7flmce2ka01pjgodrod19kdse3udoeet.apps.googleusercontent.com',
    iosBundleId: 'com.example.todoFirebaseDemo',
  );

}