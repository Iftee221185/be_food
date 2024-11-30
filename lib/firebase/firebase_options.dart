
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;


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
      apiKey: 'AIzaSyDZVlcujJbygwIhMaAhSM-p7_MjRAbNqnw',
      appId: '1:952146386516:android:6e0f18b3c07b098a3b97c1',
      messagingSenderId: '952146386516',
      projectId: 'be-food-4bc9b',
      storageBucket: 'be-food-4bc9b.firebasestorage.app',
      databaseURL:
      'https://be-food-4bc9b-default-rtdb.firebaseio.com');

  static const FirebaseOptions ios = FirebaseOptions(                                                                                                                                                                                                                                                                                                                                                                                                                                            
      apiKey: 'AIzaSyDZVlcujJbygwIhMaAhSM-p7_MjRAbNqnw',
      appId: '1:952146386516:android:6e0f18b3c07b098a3b97c1',
      messagingSenderId: '952146386516',
      projectId: 'be-food-4bc9b',
      storageBucket: 'be-food-4bc9b.firebasestorage.app',
      iosBundleId: 'com.iftee5.be_food',
      databaseURL:
      'https://be-food-4bc9b-default-rtdb.firebaseio.com');
}