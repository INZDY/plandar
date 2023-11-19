// ignore_for_file: non_constant_identifier_names
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
  Future<void> addEvent(
    String title,
    String location,
    DateTime startDate,
    DateTime endDate,
    bool allDay,
    String tag,
    List<String> people,
  ) async {
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

    for (String id in people) {
      await peopleCollection.add({
        'id': id,
      });
    }
  }

  //CREATE: add contact
  Future<void> addContact(String name, String email, String tel) async {
    try {
      await _initializeCurrentUser();
      DocumentSnapshot userDoc = userSnapshot.docs.first;

      await userDoc.reference.collection('contacts').add(
        {
          'name': name,
          'email': email,
          'tel': tel,
          'note': '-',
        },
      );
    } catch (e) {
      //print('Error adding contract: $e');
    }
  }

  //READ: get user details
  Future<Map<String, dynamic>?> getUserData() async {
    await _initializeCurrentUser();
    final userData = userSnapshot.docs.first.data() as Map<String, dynamic>;
    return userData;
  }

  //READ: get events from database
  Future<List<EventDetails>> getEvents() async {
    await _initializeCurrentUser();

    //event collection
    DocumentSnapshot userDoc = userSnapshot.docs.first;
    QuerySnapshot eventsSnapshot =
        await userDoc.reference.collection('events').get();

    //map event datails
    List<EventDetails> events =
        await Future.wait(eventsSnapshot.docs.map((DocumentSnapshot doc) async {
      //event data
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      //documents from people subcollection
      QuerySnapshot peopleSnapshot =
          await doc.reference.collection('people').get();

      List<String> peopleList = [];

      //map ids to list if any
      if (peopleSnapshot.docs.isNotEmpty) {
        peopleList = peopleSnapshot.docs
            .map((peopleDoc) => peopleDoc['id'] as String)
            .toList();
      }

      return EventDetails(
        id: doc.id,
        title: data['title'],
        location: data['location'],
        start_date: data['start_date'],
        end_date: data['end_date'],
        allday: data['allday'],
        tag: data['tag'],
        people: peopleList,
      );
    }).toList());

    //Sort by date
    events.sort((a, b) => (a.start_date.compareTo(b.start_date)));

    return events;
  }

  //READ: get events from database Today
  Future<List<Map<String, dynamic>>> getEventsToday(
      DateTime now, DateTime midnightToday) async {
    await _initializeCurrentUser();

    //Get document snapshot
    DocumentSnapshot userDoc = userSnapshot.docs.first;
    QuerySnapshot eventsQuery = await userDoc.reference
        .collection('events')
        .where('start_date', isGreaterThanOrEqualTo: now)
        .where('start_date', isLessThan: midnightToday)
        .orderBy('start_date')
        .get();

    //for storing events
    List<Map<String, dynamic>> eventList = [];

    //add all events to list
    for (QueryDocumentSnapshot eventDoc in eventsQuery.docs) {
      Map<String, dynamic> eventData = eventDoc.data() as Map<String, dynamic>;
      eventList.add(eventData);
    }

    return eventList;
  }

  //READ: get events from database Tomorrow
  Future<List<Map<String, dynamic>>> getEventsTomorrow(
      DateTime midnight, DateTime tomorrow) async {
    await _initializeCurrentUser();

    //Get document snapshot
    DocumentSnapshot userDoc = userSnapshot.docs.first;
    QuerySnapshot eventsQuery = await userDoc.reference
        .collection('events')
        .where('start_date', isGreaterThanOrEqualTo: midnight)
        .where('start_date', isLessThan: tomorrow)
        .orderBy('start_date')
        .get();

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
  Future<List<Map<String, dynamic>>> getContacts() async {
    await _initializeCurrentUser();

    DocumentSnapshot userDoc = userSnapshot.docs.first;
    QuerySnapshot contactsQuery =
        await userDoc.reference.collection('contacts').get();

    List<Map<String, dynamic>> contactList = [];

    for (QueryDocumentSnapshot contactDoc in contactsQuery.docs) {
      Map<String, dynamic> contactData =
          contactDoc.data() as Map<String, dynamic>;

      //attatch id to the doc details
      contactData['id'] = contactDoc.id;
      contactList.add(contactData);
    }

    return contactList;
  }

  //UPDATE: update user profile
  Future<void> updateUserDetails(Map<String, dynamic> updatedData) async {
    await _initializeCurrentUser();

    DocumentReference userReference = userSnapshot.docs.first.reference;
    await userReference.update(updatedData);
  }

  //UPDATE: update events
  Future<void> updateEvent(
    String eventId,
    String title,
    String location,
    DateTime startDate,
    DateTime endDate,
    bool allDay,
    String tag,
    List<String> people,
  ) async {
    await _initializeCurrentUser();
    DocumentSnapshot userDoc = userSnapshot.docs.first;
    DocumentReference eventRef =
        userDoc.reference.collection('events').doc(eventId);

    //Replace with new data
    await eventRef.set({
      'title': title,
      'location': location,
      'start_date': startDate,
      'end_date': endDate,
      'allday': allDay,
      'tag': tag,
    });

    CollectionReference peopleCollection = eventRef.collection('people');

    //delete existing people first
    QuerySnapshot peopleData = await peopleCollection.get();
    for (QueryDocumentSnapshot doc in peopleData.docs) {
      await doc.reference.delete();
    }

    //Add new people
    for (String id in people) {
      await peopleCollection.add({
        'id': id,
      });
    }
  }
  //UPDATE: update contacts
  Future<void> updateContact(
      String contactId, Map<String, dynamic> updatedData) async {
    await _initializeCurrentUser();

    CollectionReference contactsCollection =
        userSnapshot.docs.first.reference.collection('contacts');

    DocumentReference contactRef = contactsCollection.doc(contactId);

    await contactRef.update(updatedData);
  }

  //DELETE: delete events
  //**Note**
  //Need to loop delete subcollection before parent
  Future<void> deleteEvent(String eventId) async {
    await _initializeCurrentUser();
    DocumentSnapshot userDoc = userSnapshot.docs.first;
    DocumentReference eventRef =
        userDoc.reference.collection('events').doc(eventId);

    CollectionReference peopleCollection = eventRef.collection('people');

    //delete people subcollection first
    QuerySnapshot peopleData = await peopleCollection.get();
    for (QueryDocumentSnapshot doc in peopleData.docs) {
      await doc.reference.delete();
    }

    //Delete parent
    await eventRef.delete();
  }
  //DELETE: delete contacts
  Future<void> deleteContact(String contactId) async {
    await _initializeCurrentUser();

    CollectionReference contactsCollection =
        userSnapshot.docs.first.reference.collection('contacts');

    DocumentReference contactRef = contactsCollection.doc(contactId);

    await contactRef.delete();
  }

  //UTIL-client: does user exist
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

//extra classes
class EventDetails {
  final String id;
  final String title;
  final String location;
  final Timestamp start_date;
  final Timestamp end_date;
  final bool allday;
  final String tag;
  final List<String> people;

  EventDetails({
    required this.id,
    required this.title,
    required this.location,
    required this.start_date,
    required this.end_date,
    required this.allday,
    required this.tag,
    required this.people,
  });
}
