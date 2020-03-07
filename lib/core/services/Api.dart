import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

@immutable
class User {
  const User({this.uid});
  final String uid;
}

class Api {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseDatabase _db = FirebaseDatabase.instance;
  final String path;
  DatabaseReference ref;

  Api(this.path) {
    ref = _db.reference().child(path);
  }

  static User _userFromFirebase(FirebaseUser user) {
    return user == null ? null : User(uid: user.uid);
  }

  static Stream<User> get onAuthStateChanged {
    return auth.onAuthStateChanged.map(_userFromFirebase);
  }

  StreamSubscription<Event> getData(Function(Event) onData) {
    return ref.onChildAdded.listen(onData);
  }
}
