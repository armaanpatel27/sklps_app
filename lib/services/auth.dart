import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sklps_app/models/User.dart';
import 'package:sklps_app/services/access_data.dart';
//purpose: class containing methods for User Authentication
class AuthService{
//auth is name of import
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;
  //handling error where function is being called on exception using try-catch

//converts firebase user into a user class
  User? _userFromFireBase(auth.User? user){
    if(user == null){
      return null;
    }
      UserData.uid = user.uid;
    return User(uid: user.uid);
  }

  Stream<User?>? get user{
    return _firebaseAuth.authStateChanges().map(_userFromFireBase);
  }

  Future signInAnom() async {
    try {
      final credential = await _firebaseAuth.signInAnonymously();
      return _userFromFireBase(credential.user);
    }catch(e){
      print(e.toString());
    }
  }

  Future signInWithEmailAndPassword(String email, String password) async{
      final credential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return _userFromFireBase(credential.user);
  }

  Future registerWithEmailAndPassword(String email, String password) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    return _userFromFireBase((credential.user));
  }

  Future signOut() async {
    try{
      UserData.resetUserData();
      return await _firebaseAuth.signOut();
    }
    catch(e){
      print(e.toString());
    }
  }

  Future deleteAccount(filler, password) async {
      var result = await reauthenticateUser(password);
      if(result == true) {
        AccessData().updateField(
            "membersPublic", UserData.membersPublicId, "accountExists", false);
        UserData.resetUserData();
        return await _firebaseAuth.currentUser!.delete();
      } else {
        throw Exception("Unexpected Error");
      }
  }

  //reauthenticates User with password
  //returns true if successfully reauthenticated
  //returns false otherwise
  //onFireBaseException --> throws exception to be handled elsewhere
  Future<bool?> reauthenticateUser(String password) async {
      var authCredential = auth.EmailAuthProvider.credential(
          email: _firebaseAuth.currentUser!.email!, password: password);
      try{
      await _firebaseAuth.currentUser!.reauthenticateWithCredential(
          authCredential);
      return true;
    } on auth.FirebaseAuthException catch (e) {
      throw auth.FirebaseAuthException(code: e.code);
    } catch(e) {
      return false;
    }
  }

  Future changeEmail(email, password) async {
      dynamic reauthenticate = await reauthenticateUser(password);
      if(reauthenticate == true) {
        return await _firebaseAuth.currentUser!.updateEmail(email);
      } else {
        throw Exception("Unexpected Error");
      }
    }

  /*Future test(email,password)async {
    print(email);
    print(password);
  }

   */

}