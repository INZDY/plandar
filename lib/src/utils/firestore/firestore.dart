import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  //firebase, firestore instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  late User? _user;
  late QuerySnapshot userSnapshot;

  //initialize user upon calling service
  FirestoreService() {
    _initializeCurrentUser();
  }

  //Private method to initialize user
  Future<void> _initializeCurrentUser() async {
    _user = _auth.currentUser;

    if (_user != null) {
      userSnapshot = await _db
          .collection('users')
          .where('email', isEqualTo: _user!.email)
          .get();
      if (userSnapshot.docs.isNotEmpty) return;
    }
  }

  //-------------------------------------------------------------

  //CREATE: add new user details
  Future addUserDetails(String username, String email) async {
    await _db.collection('users').add(
      {
        'username': username,
        'email': email,
        'firstname': '',
        'middlename': '',
        'lastname': '',
        'birthday': DateTime(2000, 1, 1),
        'gender': 'Other',
        'phone_number': '',
        'address': '',
      },
    );
  }

  //CREATE: add event
  Future<void> addEvent(String title, String location, DateTime startDate,
      DateTime endDate, bool allDay, String tag, List<String> people) async {
    try {
      await _initializeCurrentUser();
      DocumentSnapshot userDoc = userSnapshot.docs.first;
      DocumentReference eventRef =
          await userDoc.reference.collection('events').add(
        {
          'title': title,
          'location': location,
          'start_date': startDate,
          'end_date': endDate,
          'allday': allDay,
          'tag': tag,
        },
      );
      CollectionReference peopleCollection = eventRef.collection('people');

      for (String name in people) {
        await peopleCollection.add({
          'name': name,
        });
      }
    } catch (e) {
      print('Error adding event $e');
    }
  }
  //CREATE: add contact

  //READ: get user details
  Future<Map<String, dynamic>?> getUserData() async {
    await _initializeCurrentUser();
    final userData = userSnapshot.docs.first.data() as Map<String, dynamic>;
    return userData;
  }

  //READ: get events from database
  Future<List<Map<String, dynamic>>?> getEvents() async {
    await _initializeCurrentUser();

    //Get document snapshot
    DocumentSnapshot userDoc = userSnapshot.docs.first;
    QuerySnapshot eventsQuery =
        await userDoc.reference.collection('events').get();

    //for storing events
    List<Map<String, dynamic>> eventList = [];

    //add all events to list
    for (QueryDocumentSnapshot eventDoc in eventsQuery.docs) {
      Map<String, dynamic> eventData = eventDoc.data() as Map<String, dynamic>;
      eventList.add(eventData);
    }

    return eventList;
  }

  //READ: get contacts from database

  //UPDATE: update user profile
  Future<void> updateUserDetails(Map<String, dynamic> updatedData) async {
    await _initializeCurrentUser();

    DocumentReference userReference = userSnapshot.docs.first.reference;
    await userReference.update(updatedData);
  }

  //UPDATE: update events
  //UPDATE: update contacts

  //DELETE: delete events
  //DELETE: delete contacts

  //UTIL: does user exist
  Future<bool> existUser(String email) async {
    userSnapshot =
        await _db.collection('users').where('email', isEqualTo: email).get();

    if (userSnapshot.docs.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }
}
