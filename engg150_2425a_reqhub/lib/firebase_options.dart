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
    apiKey: 'AIzaSyAgERyIucNh3QOW90r1hf3rpARFGrDAvsg',
    appId: '1:359949500637:web:46974d1a836a7086801b34',
    messagingSenderId: '359949500637',
    projectId: 'engg150-2425a-resqhub',
    authDomain: 'engg150-2425a-resqhub.firebaseapp.com',
    storageBucket: 'engg150-2425a-resqhub.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDjfdie4mEe1ZvlFKofL4sA6biH5MPLwKY',
    appId: '1:359949500637:android:7303229bf5c1bc8f801b34',
    messagingSenderId: '359949500637',
    projectId: 'engg150-2425a-resqhub',
    storageBucket: 'engg150-2425a-resqhub.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAEfPp-XEwp2LHi84MptbO_W4v_yttKVXA',
    appId: '1:359949500637:ios:7cffe63bf8c41c65801b34',
    messagingSenderId: '359949500637',
    projectId: 'engg150-2425a-resqhub',
    storageBucket: 'engg150-2425a-resqhub.firebasestorage.app',
    iosBundleId: 'com.example.engg1502425aReqhub',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAEfPp-XEwp2LHi84MptbO_W4v_yttKVXA',
    appId: '1:359949500637:ios:7cffe63bf8c41c65801b34',
    messagingSenderId: '359949500637',
    projectId: 'engg150-2425a-resqhub',
    storageBucket: 'engg150-2425a-resqhub.firebasestorage.app',
    iosBundleId: 'com.example.engg1502425aReqhub',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAgERyIucNh3QOW90r1hf3rpARFGrDAvsg',
    appId: '1:359949500637:web:077b429e9d0ece78801b34',
    messagingSenderId: '359949500637',
    projectId: 'engg150-2425a-resqhub',
    authDomain: 'engg150-2425a-resqhub.firebaseapp.com',
    storageBucket: 'engg150-2425a-resqhub.firebasestorage.app',
  );

}