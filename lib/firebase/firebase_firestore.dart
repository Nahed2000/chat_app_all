import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/info.dart';

class FBFireStore {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<bool> createMessage({required Info info}) async {
    return await firebaseFirestore
        .collection('messages')
        .add(info.toJson())
        .then((value) => true)
        .catchError((onError) => false);
  }

  // Future<void> readMessage() async {
  //   await for (var snapshot in firebaseFirestore.collection('messages')
  //       .snapshots()) {
  //     for (var message in snapshot.docs) {
  //       print(message);
  //     }
  //   }
  // }
  Stream<QuerySnapshot<Info>> readMessage() async* {
    yield* firebaseFirestore
        .collection('messages').orderBy('time')
        .withConverter<Info>(
      fromFirestore: (snapshot, options) =>
          Info.fromJson(snapshot.data()!),
      toFirestore: (value, options) => Info().toJson(),
    )
        .snapshots();
  }
}