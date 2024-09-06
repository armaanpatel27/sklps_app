import 'package:flutter/material.dart';
import 'package:sklps_app/services/search_helper.dart';
import 'package:sklps_app/shared/constants.dart';
import 'package:sklps_app/shared/size_config.dart';
import '../../../shared/text_formatting.dart';
class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {

  //creates instance of class that provides helper methods to perform search
  SearchHelper searchHelper = SearchHelper();


  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        bottom: false,
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
                  height: SizeConfig.safeBlockVertical*6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(width: 2.5),
                  ),
                  child: Center(
                    child: TextFormField(
                      textAlignVertical: TextAlignVertical.center,
                      style: TextStyle(
                        fontSize: SizeConfig.safeBlockVertical * 2.3,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search name, gaam, location",
                        prefixIcon:  SizedBox(
                          height: SizeConfig.safeBlockVertical * 2.5,
                          width: SizeConfig.safeBlockVertical * 2.5,
                          child: const Icon(
                            Icons.search,
                          ),
                        ),
                      ),
                      //executes search and updates UI when text length > 3
                      onChanged: (text) async {
                        text = text.trim();
                        //prevents loading an unnecessary amount of data
                        if(text.length < 3){
                          //resets search results
                            searchHelper.resetState();
                            searchHelper.returnedUsersMap = [];
                            //updates UI
                            setState(() {});
                        }else {
                          //capitalizes first letter of every word to match data in database
                          String newText = TextFormatting().formatEnteredText(text);

                          //searches FireStore database for matching Users and stores them in a List
                          await searchHelper.performSearch(newText, context);

                          //updates state to display user tiles corresponding to the Users stored in the List
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
                    itemCount: searchHelper.returnedUsersMap.length,
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
                                text: searchHelper.returnedUsersMap[index]["name"],
                                sizeMultiplier: 2.5,
                                color: Colors.black,
                                bold: FontWeight.bold,
                                align: TextAlign.left,
                              ),
                              trailing: TextDefault(
                                //access properties("gaam", "city") of user and displays it
                                text: "${searchHelper.returnedUsersMap[index]["gaam"]}\n${searchHelper.returnedUsersMap[index]["city"]}",
                                sizeMultiplier: 2,
                                color: Colors.black,
                                align: TextAlign.right,
                              ),
                            ),
                            onTap: (){
                              //shows pop up menu which reveals data about each user and allows for admin to edit
                              //passes index to match index in returnedUsers list
                              searchHelper.showPopUp(context, index);
                            }
                          ),
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

