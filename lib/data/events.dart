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
  Map events = {};
  int maxthumbIndex = 0;
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

    while (thumbIdx >= maxthumbIndex) {
      final response = await db
          ?.collection('thumbnails')
          .doc(maxthumbIndex.toString())
          .get();
      events.addAll(response!.data() ?? {});
      maxthumbIndex++;
    }
    final eventData = events[id.toString()];
    if (eventData != null && eventData['thumb'].substring(0, 4) != 'http') {
      eventData['thumb'] =
          await storage!.ref('posters/${eventData["thumb"]}').getDownloadURL();
    }
    return eventData;
  }

  Future<Map<String, dynamic>> getEvent(int index) async {
    int id = eventsCount - index - 1;
    final response = await db!.collection('events').doc(id.toString()).get();
    final data = response.data();
    data!['poster'] =
        await storage!.ref('posters/${data["poster"]}').getDownloadURL();
    return data;
  }

  void refresh() {
    events.clear();
    maxthumbIndex = 0;
    notifyListeners();
  }

  Future<String?> createEvent(int? id, String name, String writeUp, String link,
      String action, String path, String date, int status, int type) async {
    int nextId;
    String newName;
    if (id == null) {
      nextId = eventsCount;
      newName = '$nextId-poster${extension(path)}';
      await storage?.ref("posters/$newName").putFile(File(path));
    } else {
      nextId = id;
      if (path.substring(0, 4) == 'http') {
        newName = '$nextId-poster${extension(storage!.refFromURL(path).name)}';
      } else {
        newName = '$nextId-poster${extension(path)}';
        await storage?.ref("posters/$newName").putFile(File(path));
      }
    }
    try {
      await db!.runTransaction((transaction) async {
        // Reads

        final curThumbnail = await transaction.get(
            db!.collection('thumbnails').doc('${nextId ~/ eventsPerThumb}'));

        // Writes
        if (id == null) {
          transaction.update(
              db!.collection('state').doc('0'), {'events_count': nextId + 1});
        }
        transaction.set(db!.collection('events').doc('$nextId'), {
          'name': name,
          'action': action,
          'write_up': writeUp,
          'link': link,
          'poster': newName,
          'date': date,
          'status': status,
          'type': type,
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
    refresh();
  }

  Future<void> deleteEvent(int id) async {
    final docRef = db!.collection('events').doc(id.toString());
    final doc = await docRef.get();
    final data = doc.data();
    await storage!.ref("posters/${data!['poster']}").delete();
    await db!.runTransaction((transaction) async {
      transaction.delete(docRef);
      final thumbIdx = id ~/ eventsPerThumb;
      transaction.update(
          db!.collection('thumbnails').doc(thumbIdx.toString()), {'$id': null});
    });
    refresh();
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
