import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sklps_app/models/User.dart';
import 'package:sklps_app/services/access_data.dart';

//purpose: methods that help verify email, verify admin status, and set doc ID into userData class
class VerifyUser {
  final _firebaseAuth = FirebaseAuth.instance;
  final firestoreRef = FirebaseFirestore.instance;
  AccessData accessData = AccessData();

  //returns true if email is found inside memberEmails collection and false otherwise
  Future<bool> verifyEmail(String email) async {
    try {
      final doc = await firestoreRef
          .collection("memberEmails")
          .doc(email)
          .get();
      return doc.exists;
    } catch (e) {
      print(e.toString());
      throw Future.error("Encountered an error with memberEmails lookup in verifyEmail");
    }
  }

//purpose: stores the doc id and updates info accordingly inside UserData class
  //return boolean indicate whether process was successful or not --> handled by FutureBuilder in verify_screen
  Future<bool> setUid() async {
    try {
      // Force-refresh token so Firestore rules see email_verified == true
      await _firebaseAuth.currentUser?.getIdToken(true);
      String userUID = _firebaseAuth.currentUser!.uid;

      //stores the document corresponding to the user
      DocumentSnapshot publicDoc =
          await AccessData().searchDocByEmail("membersPublic");
      UserData.setUserData(userUID, publicDoc);
      //flags that the account now exists
      AccessData().updateField("membersPublic",
          UserData.docID, "accountExists", true);
      return true;
    } catch (e) {
      print(e.toString());
      throw Future.error("Encountered an error with searchDocByEmail function in access_data.dart or setUserData");
    }
  }

  //returns true if user has admin privileges, otherwise returns false
  Future<bool> isAdmin() async {
    try {
      return await AccessData()
          .getField("membersPublic", UserData.membersPublicId, "isAdmin");

    } catch(e) {
      print(e.toString());
      throw Future.error("Encountered an error with getField function in access_data.dart");
    }
  }
}
