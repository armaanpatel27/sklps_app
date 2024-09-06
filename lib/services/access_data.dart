import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sklps_app/services/verify_user.dart';

//purpose: provides methods to read and write data in specified collections
//handles error where function is called using try-catch
class AccessData {

  final _firebaseAuth = FirebaseAuth.instance;
  final _firestoreRef = FirebaseFirestore.instance;

//purpose: searches FireStore collection and returns a document by matching email to the email in its field
  //precondition: each document has unique email --> List will only contain one element --> returns that element
  Future<DocumentSnapshot> searchDocByEmail(String collectionName) async {
    List<DocumentSnapshot> listDocs = [];
    //stores JsonQuerySnapshot containing all documents that match
    QuerySnapshot snapshotDoc = await _firestoreRef.collection(collectionName)
        .where("email", isEqualTo: _firebaseAuth.currentUser!.email)
        .get();
    //add the document to list
    for(var document in snapshotDoc.docs) {
      listDocs.add(document);
    }
    return (listDocs[0]);
  }

  //purpose: updates a certain field inside a document
  Future<void> updateField(String collectionName, String docID, String field,
      dynamic newValue) async {
    _firestoreRef.collection(collectionName).doc(docID).set(
        {field: newValue}, SetOptions(merge: true));
  }

  //purpose: returns value of specified field within specified document
  Future<dynamic> getField(String collectionName, String docID,
      String field) async {
    DocumentSnapshot doc = await _firestoreRef.collection(collectionName)
        .doc(docID)
        .get();
    Map mapData = doc.data() as Map;
    return mapData[field];
  }

  //purpose: returns List of all documents as a result of a search
  Future<List<DocumentSnapshot>> searchCollection(String collectionName,
      String field, String enteredText) async {
    List<DocumentSnapshot> listDocs = [];
    //does not perform search if enteredText is too short
    //prevents unnecessary loading of data
    if (enteredText.length < 3) {
      return listDocs;
    } else {
      QuerySnapshot snapshotDoc = await _firestoreRef.collection(collectionName)
          .where(
          field.toLowerCase(), isGreaterThanOrEqualTo: enteredText)
          .where(field.toLowerCase(),
          isLessThan: enteredText + "zzzzzzzzzzzzzzzzzzzzzzzz")
          .get(); //stores JsonQuerySnapshot containing all documents that match
      //for each document in JsonQuerySnapshot --> add it to listDocs
      for(var documents in snapshotDoc.docs) {
        listDocs.add(documents);
      }
      return listDocs;
    }
  }
  //purpose: converts documentSnapshots of FireStore docs into Maps and stores it in a list
  List<Map<dynamic, dynamic>> docSnapshotToMap(List<DocumentSnapshot> resultList) {
    List<Map<dynamic, dynamic>> mapResults = [];
    //convert each document in passed List into a Map --> add Map to returned List
    for(var document in resultList) {
      Map mapData = document.data() as Map;
      mapData["docID"] = document.id;
      mapResults.add(mapData);
    }
    return mapResults;
  }

  //creates new FireStore document in "membersPublic" collection
  Future<void> addDocument(String name, String email) async {
    //ensure that email doesn't already exist in database(don't want duplicates)
    var emailInUse = await VerifyUser().verifyEmail(email);
    if(!emailInUse) {
      //map of all fields and their values for new document
      final data = {"address" : "", "child1" : "", "child2": "", "child3":"", "child4": "", "child5" : "",
        "city": "", "email": email, "gaam": "", "name": name, "phoneNumber": "", "spouse":"", "spouseEmail" : "", "state": "","zip": "",
        "accountExists": false, "isAdmin" : false, "father": "", "mother": "",};
      //creates a new FireStore Document with auto-generated ID
      await _firestoreRef.collection("membersPublic").add(data);
    } else {
      throw Exception("email-in-use");
    }
  }

  //retrieves all the documents inside a collection and stores them as a map inside a list
  Future<List<Map<dynamic, dynamic>>> getAllDocuments(String collectionName) async {
    var snapshot = await  _firestoreRef.collection(collectionName).get();
    return await docSnapshotToMap(snapshot.docs);
  }

  //deletes a specific document
  Future<void> deleteDoc(String collectionName, String docID) async {
    return await _firestoreRef.collection(collectionName).doc(docID).delete();
  }

  //adds a new Document to specified collection with specified data
  Future<void> newDocument(String collectionName, Map<String, dynamic> data) async {
    await _firestoreRef.collection(collectionName).add(data);
  }
}




