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
    apiKey: 'AIzaSyCINIsEHhPxh_Z828vSfAVhWJWqacfUR1c',
    appId: '1:370508232603:web:552771231d63521c2d933e',
    messagingSenderId: '370508232603',
    projectId: 'city-guide-c55ac',
    authDomain: 'city-guide-c55ac.firebaseapp.com',
    storageBucket: 'city-guide-c55ac.firebasestorage.app',
    measurementId: 'G-V61ZGKPGQV',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBbcSb2OG_Ahr-1U_Q_9tQpW5Ss0Xk1A4w',
    appId: '1:370508232603:android:727d129c1f4337722d933e',
    messagingSenderId: '370508232603',
    projectId: 'city-guide-c55ac',
    storageBucket: 'city-guide-c55ac.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBTNMpHV9ZViHUb8aK53qHY0kEeD0W7G2k',
    appId: '1:370508232603:ios:2ba33913ff608c6b2d933e',
    messagingSenderId: '370508232603',
    projectId: 'city-guide-c55ac',
    storageBucket: 'city-guide-c55ac.firebasestorage.app',
    iosBundleId: 'com.example.cityGuide',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBTNMpHV9ZViHUb8aK53qHY0kEeD0W7G2k',
    appId: '1:370508232603:ios:2ba33913ff608c6b2d933e',
    messagingSenderId: '370508232603',
    projectId: 'city-guide-c55ac',
    storageBucket: 'city-guide-c55ac.firebasestorage.app',
    iosBundleId: 'com.example.cityGuide',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCINIsEHhPxh_Z828vSfAVhWJWqacfUR1c',
    appId: '1:370508232603:web:27c6134e3ab366cd2d933e',
    messagingSenderId: '370508232603',
    projectId: 'city-guide-c55ac',
    authDomain: 'city-guide-c55ac.firebaseapp.com',
    storageBucket: 'city-guide-c55ac.firebasestorage.app',
    measurementId: 'G-228F2GM9NS',
  );
}
