//takes info from current User document and stores it in here


import 'package:cloud_firestore/cloud_firestore.dart';

class User{
  String? uid;
  User({this.uid});
}

class UserData{
  static String docID = "";
  static String uid = "";
  static String membersPublicId=  "";
  static String name =  "";
  static String email = "";
  static String phoneNumber = "";
  static String gaam = "";
  static String address = "";
  static String city = "";
  static String state = "";
  static String zip = "";
  static String spouse = "";
  static String father = "";
  static String mother = "";
  static String child1 = "";
  static String child2 = "";
  static String child3 = "";
  static String child4 = "";
  static String child5 = "";
  static bool accountExists = false;

  static bool isEmpty(){
    if(uid == " " && membersPublicId == " "){
      return true;
    }else{
      return false;
    }
  }
  
  static void setUserData(String _uid, DocumentSnapshot doc){//todo finish
    Map mapData = doc.data() as Map;
    docID = doc.id;
    uid = _uid;
    membersPublicId =doc.id;
    name = mapData["name"];
    email = mapData["email"];
    phoneNumber =mapData["phoneNumber"];
    gaam = mapData["gaam"];
    address = mapData["address"];
    city = mapData["city"];
    state = mapData["state"];
    zip = mapData["zip"];
    spouse = mapData["spouse"];
    child1 = mapData["child1"];
    child2 = mapData["child2"];
    child3 = mapData["child3"];
    child4 = mapData["child4"];
    child5 = mapData["child5"];
    accountExists = mapData["accountExists"];
    father = mapData["father"];
    mother = mapData["mother"];
  }
  static void resetUserData(){
    uid  = "";
    membersPublicId  = "";
    name  = "";
    email  = "";
    phoneNumber  = "";
    gaam  = "";
    address  = "";
    city  = "";
    state  = "";
    zip  = "";
    spouse  = "";
    child1  = "";
    child2  = "";
    child3  = "";
    child4  = "";
    child5  = "";
    accountExists = false;
    father = "";
    mother = "";
  }
  static void setEmail(String value) {
    email = value;
  }

}