import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class EventModel extends ChangeNotifier {
  bool ready = false;
  var writeAccess = false;
  User? user;

  String get email {
    return user?.email ?? 'No active user';
  }

  void toggleWrite() {
    writeAccess = !writeAccess;
    notifyListeners();
  }

  void logout() {
    if (user != null) {
      writeAccess = false;
      FirebaseAuth.instance.signOut();
      user = null;
      notifyListeners();
    }
  }

  Future<String?> createEvent(
    String name,
    String writeUp,
    String link,
    String path,
    String date,
    int status,
  ) async {
    print({
      name,
      writeUp,
      link,
      path,
      date,
      status,
    });
    return await Future.delayed(Duration(seconds: 3), () => 'Failed to Create');
  }

  Future<bool> login(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email.trim(), password: password);
      user = credential.user;
      writeAccess = true;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      print(e.code);
      return false;
    }
  }

  EventModel() {
    Firebase.initializeApp().then((value) {
      user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        writeAccess = true;
      }
      ready = true;
    });
  }
}
