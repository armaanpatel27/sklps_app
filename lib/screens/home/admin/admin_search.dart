import 'package:flutter/material.dart';
import 'package:sklps_app/services/search_helper.dart';
import 'package:sklps_app/shared/constants.dart';
import 'package:sklps_app/shared/size_config.dart';
import '../../../shared/text_formatting.dart';

class AdminSearch extends StatefulWidget {
  const AdminSearch({Key? key}) : super(key: key);

  @override
  State<AdminSearch> createState() => _AdminSearchState();
}

class _AdminSearchState extends State<AdminSearch> {

  //function to reset UI
  void resetUI() {
    setState(() {});

  }

  //creates instance of class that contains helper methods to perform search
  late SearchHelper adminSearchHelper;

  //on initial state build --> assigns value to adminSearchHelper
  //prevents resetting instance of adminSearchHelper everytime setState is called
  //passes setState to adminSearchHelper so helper methods can reset state of this widget
  @override
  void initState() {
    adminSearchHelper = SearchHelper(resetUI: resetUI);
    super.initState();
  }

  //keeps track of text entered into searchBar
  late String textFieldText;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        bottom: false ,
        child: Container(
          height: SizeConfig.safeBlockVertical * 90.5,
          width: SizeConfig.safeBlockHorizontal * 100,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

              //padding for search bar at top
              Padding(
                padding: EdgeInsets.fromLTRB(
                    SizeConfig.safeBlockHorizontal * 5,
                    SizeConfig.safeBlockVertical * 2,
                    SizeConfig.safeBlockHorizontal * 5,
                SizeConfig.safeBlockVertical * 2),
                //Container for search bar
                child: Container(
                  height: SizeConfig.safeBlockVertical * 6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(width: 2.5),
                  ),
                  child: Center(
                    child: TextFormField(
                      textAlignVertical: TextAlignVertical.center,
                      style: TextStyle(
                        fontSize: SizeConfig.safeBlockVertical * 2.3,
                        color: Colors.black
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search name, gaam, location",
                        prefixIcon: SizedBox(
                          height: SizeConfig.safeBlockVertical * 2.5,
                          width: SizeConfig.safeBlockVertical * 2.5,
                          child: const Icon(
                            Icons.search,
                          ),
                        ),
                      ),

                      //executes search and updates UI when user enters text of length > 3
                      onChanged: (text) async {
                        text = text.trim();

                        //prevents loading an unnecessary amounts of data
                        if (text.length < 3) {
                          //resets search results
                            adminSearchHelper.resetState();
                            adminSearchHelper.returnedUsersMap = [];
                            //updates UI
                            setState(() {});
                        } else {
                          //Capitalizes first letter of every word
                          String newText = TextFormatting().formatEnteredText(text);
                          textFieldText = newText;

                          //searches FireStore for users based on user input and stores them in a List
                            await adminSearchHelper.performSearch(textFieldText, context);
                            setState(() {});
                        }
                      },
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(
                  width: SizeConfig.safeBlockHorizontal * 92,
                  //Listview contains displays ListTiles to display user tiles
                  child: ListView.builder(
                    //amount of ListTiles = how many user in returnedUsersMap List
                    itemCount: adminSearchHelper.returnedUsersMap.length,
                    //builds each ListTile for each user
                    //index corresponds to index of ListTile and index of user in returnedUsersMap List
                    itemBuilder: (context, index) => SizedBox(
                      height: SizeConfig.safeBlockVertical * 13,
                      //Card contains ListTile
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: const BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        color: Colors.white,
                        //InkWell allows ListTile to receive an onTap event
                        child: InkWell(
                            child: ListTile(
                              title: TextDefault(
                                //accesses name of user and displays it
                                text: adminSearchHelper.returnedUsersMap[index]["name"],
                                sizeMultiplier: 2.5,
                                color: Colors.black,
                                bold: FontWeight.bold,
                                align: TextAlign.left,
                              ),
                              trailing: TextDefault(
                                text:
                                    //access properties("gaam", "city") of user and displays it
                                    "${adminSearchHelper.returnedUsersMap[index]["gaam"]}\n${adminSearchHelper.returnedUsersMap[index]["city"]}",
                                sizeMultiplier: 2,
                                color: Colors.black,
                                align: TextAlign.right,
                              ),
                            ),

                            //shows pop up menu which reveals data about each user and allows for admin to edit
                            //passes index to match index in returnedUsers list
                            //passes textFieldText to performSearch again once admin changes are submitted
                            onTap: () {
                                adminSearchHelper.showPopUpAdmin(
                                    context, index, textFieldText);
                            }),

                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



