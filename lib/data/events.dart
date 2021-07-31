import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class EventModel extends ChangeNotifier {
  bool ready = false;
  var writeAccess = false;
  void toggleWrite() {
    writeAccess = !writeAccess;
    notifyListeners();
  }

  EventModel() {
    Firebase.initializeApp().then((value) => ready = true);
  }
}
