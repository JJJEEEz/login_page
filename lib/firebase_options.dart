import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAvPgzJOOrNmKQamw_ustRgzrfbbwazEsY',
    appId: '1:1063573436781:web:ccd95469618cb626070264',
    messagingSenderId: '1063573436781',
    projectId: 'doctor-appointment-app-juan',
    authDomain: 'doctor-appointment-app-juan.firebaseapp.com',
    storageBucket: 'doctor-appointment-app-juan.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDK3XEoAdxUlc14hO-SeXX2nHa3Fv580cI',
    appId: '1:1063573436781:android:545de9a3fbed901b070264',
    messagingSenderId: '1063573436781',
    projectId: 'doctor-appointment-app-juan',
    storageBucket: 'doctor-appointment-app-juan.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB14hx51X3c8YmAApN8ypyKXXzwVVY_N4Q',
    appId: '1:1063573436781:ios:bc2196ce4692311b070264',
    messagingSenderId: '1063573436781',
    projectId: 'doctor-appointment-app-juan',
    storageBucket: 'doctor-appointment-app-juan.firebasestorage.app',
    iosBundleId: 'com.example.login',
  );
}
