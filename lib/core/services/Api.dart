import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Api {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseDatabase _db = FirebaseDatabase.instance;
  final String path;
  DatabaseReference ref;

  Api(this.path) {
    ref = _db.reference().child(path);
  }

  StreamSubscription<Event> getData(Function(Event) onData) {
    return ref.onChildAdded.listen(onData);
  }
}
