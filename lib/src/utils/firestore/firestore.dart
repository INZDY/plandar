import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  //firebase, firestore instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  late User? _user;

  //initialize user upon calling service
  FirestoreService() {
    _initializeCurrentUser();
  }

  //Private method to initialize user
  Future<void> _initializeCurrentUser() async {
    _user = _auth.currentUser;
    if (_user == null) return;
  }

  //-------------------------------------------------------------

  //CREATE: add user details
  Future addUserDetails(String username, String email) async {
    await FirebaseFirestore.instance
        .collection('users')
        .add({'username': username, 'email': email});
  }

  //CREATE: add event

  //READ: get user details
  Future<Map<String, dynamic>?> getUserData() async {
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

  //READ: get events from database
  Future<List<Map<String, dynamic>>?> getEvents() async {
    //Query user's doc first
    //use query snapshot to not cut out subcollection
    QuerySnapshot querySnapshot = await _db
        .collection('users')
        .where('email', isEqualTo: _user!.email)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      //Get document snapshot
      DocumentSnapshot userDoc = querySnapshot.docs.first;
      QuerySnapshot eventsQuery =
          await userDoc.reference.collection('events').get();

      //for storing events
      List<Map<String, dynamic>> eventList = [];

      //add all events to list
      for (QueryDocumentSnapshot eventDoc in eventsQuery.docs) {
        Map<String, dynamic> eventData =
            eventDoc.data() as Map<String, dynamic>;
        eventList.add(eventData);
      }

      return eventList;
    } else {
      return [];
    }
  }

  //UPDATE: update user given doc id
  //UPDATE: update events given doc id

  //DELETE: delete events given doc id
}
