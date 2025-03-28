import 'dart:io';

import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

Future<void> initializeFirebase() {
  if (Platform.isIOS) {
    return Firebase.initializeApp(options: firebaseOptionsIOS);
  } else {
    return Firebase.initializeApp(options: firebaseOptionsAndroid);
  }
}
