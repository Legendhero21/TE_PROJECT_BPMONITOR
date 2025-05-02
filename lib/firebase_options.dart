// File: lib/firebase_options.dart

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError('Web is not supported in this setup.');
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDr6maL_1_Cw1BQrwpZndz09AadxFolYxc',
    appId: '1:934128067887:android:c8833e7ab1446034d1edda',
    messagingSenderId: '934128067887',
    projectId: 'bp-database-d0467',
    databaseURL: 'https://bp-database-d0467-default-rtdb.firebaseio.com',
    storageBucket: 'bp-database-d0467.appspot.com',
  );
}
