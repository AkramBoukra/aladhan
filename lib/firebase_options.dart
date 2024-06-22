import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    } else {
      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
          return android;
        case TargetPlatform.iOS:
          return ios;
        case TargetPlatform.macOS:
          throw UnsupportedError(
              "DefaultFirebaseOptions n'a pas été configuré pour Macos - "
              "vous pouvez reconfigurer cela en exécutant à nouveau la CLI FlutterFire.");
        case TargetPlatform.fuchsia:
          // TODO: Handle this case.
          break;
        case TargetPlatform.linux:
          // TODO: Handle this case.
          break;
        case TargetPlatform.windows:
          // TODO: Handle this case.
          break;
      }
    }
    throw UnsupportedError(
      "Les options DefaultFirebaseOptions ne sont pas prises en charge pour cette plate-forme.",
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyBGBORc2b2DsDZn6JtsWmqRyA-9U4tlTfk",
    appId: "1:106973451391:web:79d2a549b54fda2c7e1b4a",
    messagingSenderId: "106973451391",
    projectId: "aladhan-4ab28",
    authDomain: "aladhan-4ab28.firebaseapp.com",
    storageBucket: "aladhan-4ab28.appspot.com",
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "AIzaSyBGBORc2b2DsDZn6JtsWmqRyA-9U4tlTfk",
    appId: "1:106973451391:web:79d2a549b54fda2c7e1b4a",
    messagingSenderId: "106973451391",
    projectId: "aladhan-4ab28",
    authDomain: "aladhan-4ab28.firebaseapp.com",
    storageBucket: "aladhan-4ab28.appspot.com",
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: "AIzaSyBGBORc2b2DsDZn6JtsWmqRyA-9U4tlTfk",
    appId: "1:106973451391:web:79d2a549b54fda2c7e1b4a",
    messagingSenderId: "106973451391",
    projectId: "aladhan-4ab28",
    authDomain: "aladhan-4ab28.firebaseapp.com",
    storageBucket: "aladhan-4ab28.appspot.com",
  );
}