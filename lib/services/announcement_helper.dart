import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sklps_app/services/access_data.dart';
//provides methods for Announcements and Events page
//includes methods to handle Timestamp and DateTime objects
class AnnouncementHelper {
  AccessData _accessData = AccessData();
  //converts Timestamp from FireStore into a String
  String timestampToString(Timestamp timestamp) {
    //converts Timestamp object into a DateTime object
    DateTime date = timestamp.toDate();
    //ensures hours stays between 1-12
    var hour = date.hour % 12;
    if(hour == 0) {
      hour = 12;
    }
    String am_pm;
    if(date.hour >= 12) {
      am_pm = "PM";
    } else {
      am_pm = "AM";
    }
    return "${dateTimeMonth(date)}-${date.day}-${date.year} at ${hour}:${date.minute} ${am_pm}";
  }

  //returns corresponding month as a String based on its corresponding int from a DateTime object
  String dateTimeMonth(DateTime date) {
    switch(date.month) {
      case 1:
        return "January";
      case 2:
        return "February";
      case 3:
        return "March";
      case 4:
        return "April";
      case 5:
        return "May";
      case 6:
        return "June";
      case 7:
        return "July";
      case 8:
        return "August";
      case 9:
        return "September";
      case 10:
        return "October";
      case 11:
        return "November";
      case 12:
        return "December";
    }
    return "";
  }

  //sorts List based on time order --> latest to oldest
  ////TimeStamp already implements Comparable interface
  void sortListByDate(List<Map<dynamic, dynamic>> list) {
    list.sort((a, b) => b["timestamp"].compareTo(a["timestamp"]) );
  }

  //adds a new announcement to the database
  Future<void> addAnnouncement(String name, String content) async{
    //captures current date and time as a DateTime --> late converted into Timestamp
    var currentTime = DateTime.now();
    Map<String, dynamic> data = {"content":content, "name": name, "timestamp": Timestamp.fromDate(currentTime)};
    await _accessData.newDocument("announcements", data);
  }
}