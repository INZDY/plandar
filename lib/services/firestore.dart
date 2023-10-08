import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  //get collection of events

  //CREATE: add user details
  final CollectionReference userDetails =
      FirebaseFirestore.instance.collection('');

  //CREATE: add event

  //READ: get events from database

  //UPDATE: update user given doc id
  //UPDATE: update events given doc id

  //DELETE: delete events given doc id
}
