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
        //Get and return user data only the first entry (no email duplicates)
        final userData = querySnapshot.docs.first.data();
        return userData;
      } else {
        return {};
      }
    }
  }

  // //CREATE: add user details
  Future addUserDetails(String username, String email) async {
    await FirebaseFirestore.instance
        .collection('users')
        .add({'username': username, 'email': email});
  }

  //CREATE: add event

  //READ: get events from database

  //UPDATE: update user given doc id
  //UPDATE: update events given doc id

  //DELETE: delete events given doc id
}
