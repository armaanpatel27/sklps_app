import 'package:flutter/material.dart';
import 'package:sklps_app/models/User.dart';
import 'package:sklps_app/services/access_data.dart';
import 'package:sklps_app/shared/custom_dialog_box.dart';

import '../shared/constants.dart';
import '../shared/size_config.dart';
//provides methods to allow user to make changes to their information
class EditInfo {
  AccessData accessData = AccessData();
  CustomDialogBox dialogBox = CustomDialogBox();
  VoidCallback resetUI; //rebuilds account page

  EditInfo({required this.resetUI});

  //stores changes in values
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
  
  //stores current value of each user property
  String initialName = UserData.name;
  String initialEmail =UserData.email;
  String initialPhoneNumber = UserData.phoneNumber;
  String initialFather = UserData.father;
  String initialMother = UserData.mother;
  String initialSpouse = UserData.spouse;
  String initialChild1 = UserData.child1;
  String initialChild2 = UserData.child2;
  String initialChild3 = UserData.child3;
  String initialChild4 = UserData.child4;
  String initialChild5 = UserData.child5;
  String initialGaam = UserData.gaam;
  String initialAddress = UserData.address;
  String initialState = UserData.state;
  String initialZip = UserData.zip;
  String initialCity = UserData.city;

  Future<void> submitUserChanges(context) async{

    String docID = UserData.docID;
    try{
      //if the user property is changed and does not equal the original value --> update the property in FireBase
      //and updates the property in UserData
      if(newGaam != "notUsed" && newGaam != initialGaam){
        await accessData.updateField("membersPublic", docID, "gaam", newGaam.trim());
        UserData.gaam = newGaam.trim();
      }
      if(newCity != "notUsed" && newCity != initialCity){
        await accessData.updateField("membersPublic", docID, "city", newCity.trim());
        UserData.city = newCity.trim();
      }
      if(newAddress != "notUsed" && newAddress !=initialAddress){
        await accessData.updateField("membersPublic", docID, "address", newAddress.trim());
        UserData.address = newAddress.trim();
      }
      if(newEmail != "notUsed" && newEmail != initialEmail){
        await accessData.updateField("membersPublic", docID, "email", newEmail.trim());
        UserData.email = newEmail.trim();
      }
      if(newPhoneNumber != "notUsed" && newPhoneNumber != initialPhoneNumber){
        await accessData.updateField("membersPublic", docID, "phoneNumber", newPhoneNumber.trim());
        UserData.phoneNumber = newPhoneNumber.trim();
      }
      if(newFather != "notUsed" && newFather != initialFather){
        await accessData.updateField("membersPublic", docID, "father", newFather.trim());
        UserData.father = newFather.trim();
      }
      if(newMother != "notUsed" && newMother != initialMother){
        await accessData.updateField("membersPublic", docID, "mother", newMother.trim());
        UserData.mother = newMother.trim();
      }
      if(newSpouse != "notUsed" && newSpouse != initialSpouse){
        await accessData.updateField("membersPublic", docID, "spouse", newSpouse.trim());
        UserData.spouse = newSpouse.trim();
      }
      if(newChild1 != "notUsed" && newChild1 != initialChild1){
        await accessData.updateField("membersPublic", docID, "child1", newChild1.trim());
        UserData.child1 = newChild1.trim();
      }
      if(newChild2 != "notUsed" && newChild2 != initialChild2){
        await accessData.updateField("membersPublic", docID, "child2", newChild2.trim());
        UserData.child2 = newChild2.trim();
      }
      if(newChild3 != "notUsed" && newChild3 != initialChild3){
        await accessData.updateField("membersPublic", docID, "child3", newChild3.trim());
        UserData.child3 = newChild3.trim();
      }
      if(newChild4 != "notUsed" && newChild4 != initialChild4){
        await accessData.updateField("membersPublic", docID, "child4", newChild4.trim());
        UserData.child4 = newChild4.trim();
      }
      if(newChild5 != "notUsed" && newChild5 != initialChild5){
        await accessData.updateField("membersPublic", docID, "child5", newChild5.trim());
        UserData.child5 = newChild5.trim();
      }
      if(newState != "notUsed" && newState != initialState){
        await accessData.updateField("membersPublic", docID, "state", newState.trim());
        UserData.state = newState.trim();
      }
      if(newZip != "notUsed" && newZip != initialZip){
        await accessData.updateField("membersPublic", docID, "zip", newZip.trim());
        UserData.zip = newZip.trim();
      }
      if(newName != "notUsed" && newName != initialName){
        await accessData.updateField("membersPublic", docID, "name", newName.trim());
        UserData.name = newName.trim();
      }
    } catch(e) {
      dialogBox.showCustomDialogBox("An error occured. Please try again later. (Error 1013)", context);
    }
  }

  //show popup where user can edit their information
  Future<void> showEditPopUp(context) {
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
                  height: SizeConfig.safeBlockVertical * 55,
                  width: SizeConfig.safeBlockHorizontal * 94,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      //title of the pop up
                      TextDefault(
                        text: "Edit Info",
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
                        height: SizeConfig.screenHeight/3.5,
                        //allows Table to be scrollable
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
                                      color: Colors.black,
                                      text1: "Name",
                                      text2: initialName,
                                      isEditable: true,
                                      onChanged: (value){
                                        newName = value.trim();
                                      },
                                    ),
                                    TableRowColumnsAdmin(
                                      color: Colors.black,
                                      text1: "Email",
                                      text2: initialEmail,
                                      isEditable: true,
                                      onChanged: (value){
                                        newEmail = value.trim();
                                      },
                                    ),
                                  ],
                                ),
                                TableRow(
                                  decoration: BoxDecoration(color: Colors.grey[200]),
                                  children: [
                                    TableRowColumnsAdmin(
                                      color: Colors.black,
                                      text1: "Phone Number",
                                      text2: initialPhoneNumber,
                                      isEditable: true,
                                      onChanged: (value){
                                        newPhoneNumber = value.trim();
                                      },
                                    ),
                                    TableRowColumnsAdmin(
                                      color: Colors.black,
                                      text1: "Child1",
                                      text2: initialChild1,
                                      isEditable: true,
                                      onChanged: (value){
                                        newChild1 = value.trim();
                                      },
                                    ),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    TableRowColumnsAdmin(
                                      color: Colors.black,
                                      text1: "Child2",
                                      text2: initialChild2,
                                      isEditable: true,
                                      onChanged: (value){
                                        newChild2 = value.trim();
                                      },
                                    ),
                                    TableRowColumnsAdmin(
                                      color: Colors.black,
                                      text1: "Child 3",
                                      text2: initialChild3,
                                      isEditable: true,
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
                                      color: Colors.black,
                                      text1: "Child 4",
                                      text2: initialChild4,
                                      isEditable: true,
                                      onChanged: (value){
                                        newChild4 = value.trim();
                                      },
                                    ),
                                    TableRowColumnsAdmin(
                                      color: Colors.black,
                                      text1: "Child 5",
                                      text2: initialChild5,
                                      isEditable: true,
                                      onChanged: (value){
                                        newChild5 = value.trim();
                                      },
                                    ),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    TableRowColumnsAdmin(
                                      color: Colors.black,
                                      text1: "Father",
                                      text2: initialFather,
                                      isEditable: true,
                                      onChanged: (value){
                                        newFather = value.trim();
                                      },
                                    ),
                                    TableRowColumnsAdmin(
                                      color: Colors.black,
                                      text1: "Mother",
                                      text2: initialMother,
                                      isEditable: true,
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
                                      color: Colors.black,
                                      text1: "Spouse",
                                      text2: initialSpouse,
                                      isEditable: true,
                                      onChanged: (value){
                                        newSpouse = value.trim();
                                      },
                                    ),
                                    TableRowColumnsAdmin(
                                      color: Colors.black,
                                      text1: "Gaam",
                                      text2: initialGaam,
                                      isEditable: true,
                                      onChanged: (value){
                                        newGaam = value.trim();
                                      },
                                    ),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    TableRowColumnsAdmin(
                                      color: Colors.black,
                                      text1: "Street Address",
                                      text2: initialAddress,
                                      isEditable: true,
                                      onChanged: (value){
                                        newAddress= value.trim();
                                      },
                                    ),
                                    TableRowColumnsAdmin(
                                      color: Colors.black,
                                      text1: "City",
                                      text2: initialCity,
                                      isEditable: true,
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
                                      color: Colors.black,
                                      text1: "State",
                                      text2: initialState,
                                      isEditable: true,
                                      onChanged: (value){
                                        newState= value.trim();
                                      },
                                    ),
                                    TableRowColumnsAdmin(
                                      color: Colors.black,
                                      text1: "Zip",
                                      text2: initialZip,
                                      isEditable: true,
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
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Material(
                              //Submit Button
                              child: TextButton(
                                onPressed: () {
                                  //displays confirmation dialogBox
                                 showDialogBox("Are you sure you want to make these changes?", context);
                                },
                                child: TextDefault(
                                  text: "Submit",
                                  color: Colors.blue,
                                  sizeMultiplier: 2.5,
                                  align: TextAlign.right,
                                ),
                              )
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

  //resets variables in class
  void resetState() {
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

  //displays confirmation dialogBox in order to submit changes to user information
  Future<void> showDialogBox(String text, BuildContext context) {
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
            content: SizedBox(
              height: SizeConfig.safeBlockVertical * 8,
              child: TextDefault(
                text: text,
                color: Colors.black,
                sizeMultiplier: 2.5,
              ),
            ),
            actions: <Widget>[
              //Submit Button
              TextButton(
                onPressed: () async {
                  await submitUserChanges(context);
                  //pop dialogBox and popUp
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  resetUI();
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
}