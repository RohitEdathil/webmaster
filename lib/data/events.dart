import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class EventModel extends ChangeNotifier {
  final eventsPerThumb = 20;
  bool ready = false;
  var writeAccess = false;
  User? user;
  bool serverStatus = false;
  int eventsCount = 0;
  FirebaseFirestore? db;
  FirebaseStorage? storage;
  EventModel() {
    Firebase.initializeApp().then((value) {
      user = FirebaseAuth.instance.currentUser;
      storage = FirebaseStorage.instance;
      db = FirebaseFirestore.instance;
      if (user != null) {
        writeAccess = true;
      }
      db?.collection('state').doc('0').snapshots().listen(stateChangeHandler);
      ready = true;
      notifyListeners();
    });
  }

  void stateChangeHandler(DocumentSnapshot<Map<String, dynamic>> state) {
    serverStatus = state['server_status'];
    eventsCount = state['events_count'];
    notifyListeners();
  }

  String get email {
    return user?.email ?? 'No active user';
  }

  void toggleWrite() {
    writeAccess = !writeAccess;
    notifyListeners();
  }

  void toggleServerStatus() {
    db?.collection('state').doc('0').update({'server_status': !serverStatus});
  }

  void logout() {
    if (user != null) {
      writeAccess = false;
      FirebaseAuth.instance.signOut();
      user = null;
      notifyListeners();
    }
  }

  Future<String>? getPosterUrl(String name) {
    return storage?.ref('posters/$name').getDownloadURL();
  }

  Future<Map<String, dynamic>?> getThumb(int index) async {
    int id = eventsCount - index - 1;
    int thumbIdx = id ~/ eventsPerThumb;
    final thumbGroup =
        await db?.collection('thumbnails').doc('$thumbIdx').get();
    Map<String, dynamic>? data = thumbGroup!.data();
    if (data!.containsKey(id.toString())) {
      final thumbData = data[id.toString()];
      thumbData['thumb'] = await getPosterUrl(thumbData['thumb']);
      return thumbData;
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
    final newName = '$eventsCount-poster${extension(path)}';
    await storage?.ref("posters/$newName").putFile(File(path));
    try {
      await db!.runTransaction((transaction) async {
        // Reads
        final serverStatus =
            await transaction.get(db!.collection('state').doc('0'));
        int nextId = serverStatus['events_count'];
        final curThumbnail = await transaction.get(
            db!.collection('thumbnails').doc('${nextId ~/ eventsPerThumb}'));

        // Writes
        transaction.update(
            db!.collection('state').doc('0'), {'events_count': nextId + 1});
        transaction.set(db!.collection('events').doc('$nextId'), {
          'name': name,
          'write_up': writeUp,
          'link': link,
          'poster': newName,
          'date': date,
          'status': status
        });

        curThumbnail.exists
            ? transaction.update(
                db!.collection('thumbnails').doc('${nextId ~/ eventsPerThumb}'),
                {
                    '$nextId': {
                      'name': name,
                      'thumb': newName,
                      'status': status
                    }
                  })
            : transaction.set(
                db!.collection('thumbnails').doc('${nextId ~/ eventsPerThumb}'),
                {
                    '$nextId': {
                      'name': name,
                      'thumb': newName,
                      'status': status
                    }
                  });
      });
    } on FirebaseException catch (e) {
      return e.message;
    }
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
}
