import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  //firebase firestore instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? _user;

  //read all
  Future getUserData() async {
    //check if authenticated
    if (_auth.currentUser != null) {
      //get current user
      _user = _auth.currentUser;

      //Query Firestore for user data => first as query snapshot
      final querySnapshot = await _db
          .collection('users')
          .where('email', isEqualTo: _user!.email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final userData = querySnapshot.docs.first.data();
        //Get and return user data
        return userData;
      } else {
        return {};
      }
    }
  }

  // //CREATE: add user details
  // final CollectionReference userDetails =
  //     FirebaseFirestore.instance.collection('');

  //CREATE: add event

  //READ: get events from database

  //UPDATE: update user given doc id
  //UPDATE: update events given doc id

  //DELETE: delete events given doc id
}
