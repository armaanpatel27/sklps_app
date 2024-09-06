//contains helper methods for searching users in database
//used in search.dart and admin_search.dart
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sklps_app/models/User.dart';
import 'package:sklps_app/services/access_data.dart';
import 'package:sklps_app/shared/custom_dialog_box.dart';
import '../shared/constants.dart';
import '../shared/size_config.dart';

class SearchHelper {
  //constructor takes VoidCallBack function from admin_search so helper methods can update state of admin_search page
  VoidCallback? resetUI;
  SearchHelper({this.resetUI});
  AccessData accessData = AccessData();
  CustomDialogBox dialogBox = CustomDialogBox();


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
      await accessData.updateField("membersPublic", docID, "email", newEmail.trim());
      UserData.email = newEmail.trim();
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

  //displays AdminPopUp menu that displays User information and allows Admin to edit User information
  Future<void> showPopUpAdmin(context, int index, String enteredText) {

    //stores current value of each user property
    String initialName = "${returnedUsersMap[index]["name"]}";
    String initialEmail ="${returnedUsersMap[index]["email"]}";
    String initialPhoneNumber = "${returnedUsersMap[index]["phoneNumber"]}";
    String initialFather = "${returnedUsersMap[index]["father"]}";
    String initialMother = "${returnedUsersMap[index]["mother"]}";
    String initialSpouse = "${returnedUsersMap[index]["spouse"]}";
    String initialChild1 = "${returnedUsersMap[index]["child1"]}";
    String initialChild2 = "${returnedUsersMap[index]["child2"]}";
    String initialChild3 = "${returnedUsersMap[index]["child3"]}";
    String initialChild4 = "${returnedUsersMap[index]["child4"]}";
    String initialChild5 = "${returnedUsersMap[index]["child5"]}";
    String initialGaam = "${returnedUsersMap[index]["gaam"]}";
    String initialAddress = "${returnedUsersMap[index]["address"]}";
    String initialState = "${returnedUsersMap[index]["state"]}";
    String initialZip = "${returnedUsersMap[index]["zip"]}";
    String initialCity = "${returnedUsersMap[index]["city"]}";
    Uri launchPhone = Uri.parse('tel:+1-${initialPhoneNumber}');
    Uri launchEmail = Uri.parse('mailto:${initialEmail}');

    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setStatePop) { //setStatePop allows for setState to rebuild this widget
            return Center(
              child: Material(
                type: MaterialType.transparency,
                child: Container(
                  padding: EdgeInsets.all(SizeConfig.safeBlockHorizontal * 5),
                  height: SizeConfig.safeBlockVertical * 58,
                  width: SizeConfig.safeBlockHorizontal * 94,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      //title of the pop up
                      TextDefault(
                        text: returnedUsersMap[index]["name"],
                        sizeMultiplier: 3,
                        color: Colors.blue,
                        bold: FontWeight.bold,
                        align: TextAlign.center,
                      ),
                      SizedBox(
                        height: SizeConfig.safeBlockVertical * 3,
                      ),
                      //restricts size of Table
                      SizedBox(
                        height: SizeConfig.safeBlockVertical * 33,
                        //allows Table to be scrollable
                        child: Scrollbar(
                          isAlwaysShown: true,
                          child: ListView(
                            children: [
                              Table(
                              border: TableBorder.all(
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                color: Colors.black,
                              ),
                              children: [
                                TableRow(
                                  children: [
                                    //shows current value of each property
                                    //if editable and if changed --> stores new value
                                    TableRowColumnsAdmin(
                                      color: Colors.red,
                                      text1: "Name",
                                      text2: initialName,
                                      isEditable: isEditable,
                                      onChanged: (value){
                                          newName = value.trim();
                                      },
                                    ),
                                    InkWell(
                                      //launches email app
                                      onTap: () async {
                                        try{await launchUrl(launchEmail);}
                                        catch(e) {
                                          print(e.toString());
                                          print("Error #1018");
                                        };
                                      },
                                      child: TableRowColumnsAdmin(
                                        initialColor: Colors.blue[600]!,
                                        color: Colors.red,
                                        text1: "Email",
                                        text2: initialEmail,
                                        isEditable: isEditable,
                                        onChanged: (value){
                                            newEmail = value.trim();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                TableRow(
                                  decoration: BoxDecoration(color: Colors.grey[200]),
                                  children: [
                                    //launches phone app
                                    InkWell(
                                      onTap: () async {
                                        try{await launchUrl(launchPhone);}
                                        catch(e) {
                                          print(e.toString());
                                          print("Error #1019");
                                        };
                                      },
                                      child: TableRowColumnsAdmin(
                                        initialColor: Colors.blue[600]!,
                                        color: Colors.red,
                                        text1: "Phone Number",
                                        text2: initialPhoneNumber,
                                        isEditable: isEditable,
                                        onChanged: (value){
                                            newPhoneNumber = value.trim();
                                        },
                                      ),
                                    ),
                                    TableRowColumnsAdmin(
                                      color: Colors.red,
                                      text1: "Child1",
                                      text2: initialChild1,
                                      isEditable: isEditable,
                                      onChanged: (value){
                                          newChild1 = value.trim();
                                      },
                                    ),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    TableRowColumnsAdmin(
                                      color: Colors.red,
                                      text1: "Child2",
                                      text2: initialChild2,
                                      isEditable: isEditable,
                                      onChanged: (value){
                                          newChild2 = value.trim();
                                      },
                                    ),
                                    TableRowColumnsAdmin(
                                      color: Colors.red,
                                      text1: "Child 3",
                                      text2: initialChild3,
                                      isEditable: isEditable,
                                      onChanged: (value){
                                        newChild3 = value.trim();
                                      },
                                    ),
                                  ],
                                ),
                                TableRow(
                                  decoration: BoxDecoration(color: Colors.grey[200]),
                                  children: [
                                    TableRowColumnsAdmin(
                                      color: Colors.red,
                                      text1: "Child 4",
                                      text2: initialChild4,
                                      isEditable: isEditable,
                                      onChanged: (value){
                                        newChild4 = value.trim();
                                      },
                                    ),
                                    TableRowColumnsAdmin(
                                      color: Colors.red,
                                      text1: "Child 5",
                                      text2: initialChild5,
                                      isEditable: isEditable,
                                      onChanged: (value){
                                        newChild5 = value.trim();
                                      },
                                    ),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    TableRowColumnsAdmin(
                                      color: Colors.red,
                                      text1: "Father",
                                      text2: initialFather,
                                      isEditable: isEditable,
                                      onChanged: (value){
                                        newFather = value.trim();
                                      },
                                    ),
                                    TableRowColumnsAdmin(
                                      color: Colors.red,
                                      text1: "Mother",
                                      text2: initialMother,
                                      isEditable: isEditable,
                                      onChanged: (value){
                                        newMother = value.trim();
                                      },
                                    ),
                                  ],
                                ),
                                TableRow(
                                  decoration: BoxDecoration(color: Colors.grey[200]),
                                  children: [
                                    TableRowColumnsAdmin(
                                      color: Colors.red,
                                      text1: "Spouse",
                                      text2: initialSpouse,
                                      isEditable: isEditable,
                                      onChanged: (value){
                                        newSpouse = value.trim();
                                      },
                                    ),
                                    TableRowColumnsAdmin(
                                      color: Colors.red,
                                      text1: "Gaam",
                                      text2: initialGaam,
                                      isEditable: isEditable,
                                      onChanged: (value){
                                        newGaam = value.trim();
                                      },
                                    ),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    TableRowColumnsAdmin(
                                      color: Colors.red,
                                      text1: "Street Address",
                                      text2: initialAddress,
                                      isEditable: isEditable,
                                      onChanged: (value){
                                        newAddress= value.trim();
                                      },
                                    ),
                                    TableRowColumnsAdmin(
                                      color: Colors.red,
                                      text1: "City",
                                      text2: initialCity,
                                      isEditable: isEditable,
                                      onChanged: (value){
                                        newCity = value.trim();
                                      },
                                    ),
                                  ],
                                ),
                                TableRow(
                                  decoration: BoxDecoration(color: Colors.grey[200]),
                                  children: [
                                    TableRowColumnsAdmin(
                                      color: Colors.red,
                                      text1: "State",
                                      text2: initialState,
                                      isEditable: isEditable,
                                      onChanged: (value){
                                        newState= value.trim();
                                      },
                                    ),
                                    TableRowColumnsAdmin(
                                      color: Colors.red,
                                      text1: "Zip",
                                      text2: initialZip,
                                      isEditable: isEditable,
                                      onChanged: (value){
                                        newZip= value.trim();
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Material(
                              //if isEditable --> show Submit Button
                              //else --> show pencil Icon which allows user to change isEditable to true
                              child: isEditable
                                  ? TextButton(
                                onPressed: () {
                                  //displays confirmation dialogBox
                                  showDialogBox("Are you sure you want to make these changes?", context, index, enteredText);
                                },
                                child: TextDefault(
                                  text: "Submit",
                                  color: Colors.blue,
                                  sizeMultiplier: 2.5,
                                  align: TextAlign.right,
                                ),
                              )
                              //button to change value of isEditable
                                  : IconButton(
                                onPressed: () {
                                  setStatePop(() {
                                    isEditable = true;
                                  });
                                },
                                icon: Icon(Icons.edit),
                                color: Colors.blue,
                                iconSize:
                                SizeConfig.safeBlockVertical * 3,
                              ),
                            ),
                            //Button to exit popUp
                            TextButton(
                              onPressed: (){
                                resetState();
                                Navigator.of(context).pop();
                              },
                              child: TextDefault(
                                text: "Close",
                                color: Colors.blue,
                                sizeMultiplier: 2.5,
                                align: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  //displays normal PopUp menu that displays User information
  Future<void> showPopUp(context, int index){
    Uri launchPhone = Uri.parse('tel:+1-${returnedUsersMap[index]["phoneNumber"]}');
    Uri launchEmail = Uri.parse('mailto:${returnedUsersMap[index]["email"]}');
    return showDialog(
      context: context,
      builder: (context){
        return Center(
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              padding: EdgeInsets.all(SizeConfig.safeBlockHorizontal*5),
              height: SizeConfig.safeBlockVertical * 58,
              width: SizeConfig.safeBlockHorizontal * 94,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  TextDefault(
                    text: returnedUsersMap[index]["name"],
                    sizeMultiplier: 3,
                    color: Colors.blue,
                    bold: FontWeight.bold,
                    align: TextAlign.center,
                  ),
                  SizedBox(
                    height: SizeConfig.safeBlockVertical*3,
                  ),
                  SizedBox(
                    height: SizeConfig.safeBlockVertical * 33,
                    //allows Table to be scrollable
                    child: Scrollbar(
                      isAlwaysShown: true,
                      child: ListView(
                        children: [
                          Table(
                            border: TableBorder.all(
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                              color: Colors.black,
                            ),
                            children: [
                              TableRow(
                                children: [
                                  //shows current value of each property
                                  //if editable and if changed --> stores new value
                                  TableRowColumns(
                                    text1: "Name",
                                    text2: returnedUsersMap[index]["name"],
                                  ),
                                  InkWell(
                                    //launches email app
                                    onTap: () async {
                                      try{await launchUrl(launchEmail);}
                                      catch(e) {
                                        print(e.toString());
                                        print("Error #1019");
                                      };
                                    },
                                    child: TableRowColumns(

                                      text1: "Email",
                                      text2: returnedUsersMap[index]["email"],
                                      initialColor: Colors.blue[600]!,
                                    ),
                                  ),
                                ],
                              ),
                              TableRow(
                                decoration: BoxDecoration(color: Colors.grey[200]),
                                children: [
                                  InkWell(
                                    //launches phone app
                                    onTap: () async {
                                      try{await launchUrl(launchPhone);}
                                      catch(e) {
                                        print(e.toString());
                                        print("Error #1020");
                                      };
                                    },
                                    child: TableRowColumns(
                                      text1: "Phone Number",
                                      text2: returnedUsersMap[index]["phoneNumber"],
                                      initialColor: Colors.blue[600]!,
                                    ),
                                  ),
                                  TableRowColumns(

                                    text1: "Child1",
                                    text2: returnedUsersMap[index]["child1"],

                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  TableRowColumns(
                                    text1: "Child2",
                                    text2: returnedUsersMap[index]["child2"],

                                  ),
                                  TableRowColumns(
                                    text1: "Child 3",
                                    text2: returnedUsersMap[index]["child3"],
                                  ),
                                ],
                              ),
                              TableRow(
                                decoration: BoxDecoration(color: Colors.grey[200]),
                                children: [
                                  TableRowColumns(
                                    text1: "Child 4",
                                    text2: returnedUsersMap[index]["child4"],
                                  ),
                                  TableRowColumns(
                                    text1: "Child 5",
                                    text2: returnedUsersMap[index]["child5"],
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  TableRowColumns(
                                    text1: "Father",
                                    text2: returnedUsersMap[index]["father"],
                                  ),
                                  TableRowColumns(
                                    text1: "Mother",
                                    text2: returnedUsersMap[index]["mother"],
                                  ),
                                ],
                              ),
                              TableRow(
                                decoration: BoxDecoration(color: Colors.grey[200]),
                                children: [
                                  TableRowColumns(
                                    text1: "Spouse",
                                    text2:returnedUsersMap[index]["spouse"],
                                  ),
                                  TableRowColumns(
                                    text1: "Gaam",
                                    text2:returnedUsersMap[index]["gaam"],
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  TableRowColumns(
                                    text1: "Street Address",
                                    text2: returnedUsersMap[index]["address"],
                                  ),
                                  TableRowColumns(
                                    text1: "City",
                                    text2: returnedUsersMap[index]["city"],
                                  ),
                                ],
                              ),
                              TableRow(
                                decoration: BoxDecoration(color: Colors.grey[200]),
                                children: [
                                  TableRowColumns(
                                    text1: "State",
                                    text2: returnedUsersMap[index]["state"],
                                  ),
                                  TableRowColumns(
                                    text1: "Zip",
                                    text2: "${returnedUsersMap[index]["zip"]}",
                                  ),
                                ],
                              ),
                            ],
                          ),],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Align(
                          alignment: Alignment.bottomRight,
                          child: TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: TextDefault(
                              text: "Close",
                              color: Colors.blue,
                              sizeMultiplier: 2.5,
                              align: TextAlign.right,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  //displays confirmation dialogBox in order to submit changes to user information
  Future<void> showDialogBox(String text, BuildContext context, int index, String enteredText) {
    return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
                side: const BorderSide(color: Colors.black, width: 2),
              ),
              insetPadding: EdgeInsets.fromLTRB(SizeConfig.safeBlockHorizontal * 5, SizeConfig.safeBlockVertical *2, SizeConfig.safeBlockHorizontal*5, SizeConfig.safeBlockVertical*2),
              title: TextDefault(
                text:"ALERT",
                color: Colors.black,
                sizeMultiplier: 3,
                bold: FontWeight.bold,
              ),
              content: TextDefault(
                text: text,
                color: Colors.black,
                sizeMultiplier: 2.5,
              ),
              actions: <Widget>[
                //Submit Button
                TextButton(
                  onPressed: () async {
                    await submitChanges(index, context);
                    //updates UI and updates returnedUserLists
                    await stateUpdate(enteredText, context);
                    //pop dialogBox and popUp
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    resetUI!();
                    //resets state of all vars
                      resetState();
                  },
                  child: TextDefault(
                    text: "Confirm",
                    color: Colors.blue,
                    sizeMultiplier: 2.5,
                  ),
                ),
                //cancel changes button
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: TextDefault(
                    text: "Cancel",
                    color: Colors.blue,
                    sizeMultiplier: 2.5,
                  ),
                ),
              ],
            );
          });
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