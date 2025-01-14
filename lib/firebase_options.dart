import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return android;
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyADrlvLbm_bApoLlv03clvrMLbJsaNNUHo',
    appId: '1:814597562439:android:ded20a9654e6061b03d162',
    messagingSenderId: '814597562439',
    projectId: 'mfest-12e8c',
    storageBucket: 'mfest-12e8c.firebasestorage.app',
  );
}
