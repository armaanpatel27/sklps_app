//contains helper methods for searching users in database
//used in search.dart and admin_search.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sklps_app/models/User.dart';
import 'package:sklps_app/services/access_data.dart';
import 'package:sklps_app/shared/custom_dialog_box.dart';
import 'package:sklps_app/screens/home/normal/member_detail_page.dart';
import 'package:sklps_app/screens/home/admin/admin_member_detail_page.dart';

class SearchHelper {
  //constructor takes VoidCallBack function from admin_search so helper methods can update state of admin_search page
  VoidCallback? resetUI;
  SearchHelper({this.resetUI});
  AccessData accessData = AccessData();
  CustomDialogBox dialogBox = CustomDialogBox();
  final _firestoreRef = FirebaseFirestore.instance;


  //stores all of the Users returned by user search as a map containing the user's data
  //Map contains the following keys:
  //
  List<Map<dynamic, dynamic>> returnedUsersMap = [];

  //set initial value to 'notUsed' to manage which properties are updated
  //if value remains 'notUsed'(doesn't set to empty) when User submits changes --> value is not passed to FireBase
  //this prevents sending unnecessary data to Cloud FireStore
  String newEmail = "notUsed";
  String newPhoneNumber = "notUsed";
  String newFather = "notUsed";
  String newMother = "notUsed";
  String newSpouse = "notUsed";
  String newChildren = "notUsed";
  String newChild1 = "notUsed";
  String newChild2 = "notUsed";
  String newChild3 = "notUsed";
  String newChild4 = "notUsed";
  String newChild5 = "notUsed";
  String newGaam = "notUsed";
  String fullAddress = "notUsed";
  String newAddress = "notUsed";
  String newState = "notUsed";
  String newCity = "notUsed";
  String newZip = "notUsed";
  String newName = "notUsed";

  //whether or not textFormFields are editable
  bool isEditable = false;
  //performs search and updates the Lists containing the searched users
  Future<void> stateUpdate(String textFieldText, context)async {
    await performSearch(textFieldText, context);
  }



  //called onClick of Submit button --> sends over new changes to FireStore and updates data accordingly
  Future<void> submitChanges(int currentIndex, context) async{

    String docID = returnedUsersMap[currentIndex]["docID"];
    try{
    //if the user property is changed and does not equal the original value --> update the property in FireBase
      //and updates the property in UserData
      if(newGaam != "notUsed" && newGaam != "${returnedUsersMap[currentIndex]["gaam"]}"){
        await accessData.updateField("membersPublic", docID, "gaam", newGaam.trim());
        UserData.gaam = newGaam.trim();
      }
      if(newCity != "notUsed" && newCity != "${returnedUsersMap[currentIndex]["city"]}"){
        await accessData.updateField("membersPublic", docID, "city", newCity.trim());
        UserData.city = newCity.trim();
      }
      if(newAddress != "notUsed" && newAddress != "${returnedUsersMap[currentIndex]["address"]}"){
        await accessData.updateField("membersPublic", docID, "address", newAddress.trim());
        UserData.address = newAddress.trim();
      }
    if(newEmail != "notUsed" && newEmail != "${returnedUsersMap[currentIndex]["email"]}"){
      String oldEmail = "${returnedUsersMap[currentIndex]["email"]}";
      bool currentIsAdmin = returnedUsersMap[currentIndex]["isAdmin"] == true;
      await accessData.updateField("membersPublic", docID, "email", newEmail.trim());
      UserData.email = newEmail.trim();
      await _firestoreRef.collection("memberEmails").doc(oldEmail).delete();
      await _firestoreRef.collection("memberEmails").doc(newEmail.trim()).set({"isAdmin": currentIsAdmin});
    }
    if(newPhoneNumber != "notUsed" && newPhoneNumber != "${returnedUsersMap[currentIndex]["phoneNumber"]}"){
      await accessData.updateField("membersPublic", docID, "phoneNumber", newPhoneNumber.trim());
      UserData.phoneNumber = newPhoneNumber.trim();
    }
    if(newFather != "notUsed" && newFather != "${returnedUsersMap[currentIndex]["father"]}"){
      await accessData.updateField("membersPublic", docID, "father", newFather.trim());
      UserData.father = newFather.trim();
    }
    if(newMother != "notUsed" && newMother != "${returnedUsersMap[currentIndex]["mother"]}"){
      await accessData.updateField("membersPublic", docID, "mother", newMother.trim());
      UserData.mother = newMother.trim();
    }
    if(newSpouse != "notUsed" && newSpouse != "${returnedUsersMap[currentIndex]["spouse"]}"){
      await accessData.updateField("membersPublic", docID, "spouse", newSpouse.trim());
      UserData.spouse = newSpouse.trim();
    }
    if(newChild1 != "notUsed" && newChild1 != "${returnedUsersMap[currentIndex]["child1"]}"){
      await accessData.updateField("membersPublic", docID, "child1", newChild1.trim());
      UserData.child1 = newChild1.trim();
    }
    if(newChild2 != "notUsed" && newChild2 != "${returnedUsersMap[currentIndex]["child2"]}"){
      await accessData.updateField("membersPublic", docID, "child2", newChild2.trim());
      UserData.child2 = newChild2.trim();
    }
    if(newChild3 != "notUsed" && newChild3 != "${returnedUsersMap[currentIndex]["child3"]}"){
      await accessData.updateField("membersPublic", docID, "child3", newChild3.trim());
      UserData.child3 = newChild3.trim();
    }
    if(newChild4 != "notUsed" && newChild4 != "${returnedUsersMap[currentIndex]["child4"]}"){
      await accessData.updateField("membersPublic", docID, "child4", newChild4.trim());
      UserData.child4 = newChild4.trim();
    }
    if(newChild5 != "notUsed" && newChild5 != "${returnedUsersMap[currentIndex]["child5"]}"){
      await accessData.updateField("membersPublic", docID, "child5", newChild5.trim());
      UserData.child5 = newChild5.trim();
    }
    if(newState != "notUsed" && newState != "${returnedUsersMap[currentIndex]["state"]}"){
      await accessData.updateField("membersPublic", docID, "state", newState.trim());
      UserData.state = newState.trim();
    }
    if(newZip != "notUsed" && newZip != "${returnedUsersMap[currentIndex]["zip"]}"){
      await accessData.updateField("membersPublic", docID, "zip", newZip.trim());
      UserData.zip = newZip.trim();
    }
    if(newName != "notUsed" && newName != "${returnedUsersMap[currentIndex]["name"]}"){
      await accessData.updateField("membersPublic", docID, "name", newName.trim());
      UserData.name = newName.trim();
    }
    } catch(e) {
      dialogBox.showCustomDialogBox("An error occured. Please try again later. (Error 1013)", context);
    }
  }

  //navigates to full-screen admin detail page for viewing and editing user information
  Future<void> showPopUpAdmin(context, int index, String enteredText) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AdminMemberDetailPage(
          user: returnedUsersMap[index],
          index: index,
          enteredText: enteredText,
          helper: this,
        ),
      ),
    ).then((_) => resetState());
  }

  //navigates to full-screen detail page for viewing user information
  Future<void> showPopUp(context, int index) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MemberDetailPage(user: returnedUsersMap[index]),
      ),
    );
  }


  //searches FireStore for corresponding users based on user input
  //stores returned Users inside returnedUsersSnapshot List and returnedUsersMap List
  Future<void> performSearch(String enteredText, context) async {
    //store returned Users
    List<DocumentSnapshot> result = [];
    //search based on 'name' or 'gaam' or 'city'
    try{
    result = await accessData
        .searchCollection("membersPublic", "name", enteredText);
    if (result.isEmpty) {
      result = await accessData
          .searchCollection("membersPublic", "gaam", enteredText);
      if (result.isEmpty) {
        result = await accessData
            .searchCollection("membersPublic", "city", enteredText);
      }
    } } catch(e) {
      print(e.toString());
      dialogBox.showCustomDialogBox("ERROR #1012. Please try again later.", context);
    }
    //sorts the List alphabetically by name
    result.sort((a, b) {

      //compares name property in each adjacent element
      Map mapA = a.data() as Map;
      Map mapB = b.data() as Map;
      return mapA["name"].compareTo(mapB["name"]);
    });


    //converts List of JsonQueryDocumentSnapshot of users into a List of maps containing each user's data
    returnedUsersMap = accessData.docSnapshotToMap(result);
    //adds documentID and its value to the map
    for(int i =0; i<result.length; i++) {
      String docID = result[i].id;
      returnedUsersMap[i]["docID"] = docID;
    }
  }

  void resetState() {
    isEditable = false;
    newEmail = "notUsed";
    newPhoneNumber = "notUsed";
    newFather = "notUsed";
    newMother = "notUsed";
    newSpouse = "notUsed";
    newChildren = "notUsed";
    newChild1 = "notUsed";
    newChild2 = "notUsed";
    newChild3 = "notUsed";
    newChild4 = "notUsed";
    newChild5 = "notUsed";
    newGaam = "notUsed";
    fullAddress = "notUsed";
    newAddress = "notUsed";
    newState = "notUsed";
    newCity = "notUsed";
    newZip = "notUsed";
}

}