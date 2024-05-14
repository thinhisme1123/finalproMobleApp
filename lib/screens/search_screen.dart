import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Helper/SharedPreferencesHelper.dart';
import '../home/home_modes_screen.dart';
import '../model/History.dart';
import '../model/Topic.dart';
import '../model/User.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final SharedPreferencesHelper sharedPreferencesHelper = SharedPreferencesHelper();


  late List<Topic> topics =[];

  List<Topic> _filteredItems = [];

  // List<Topic> buffer = [];

  List<String> userNames = [];

  late String userID;

  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initSharedPreferences();
  }
  Future<void> _initSharedPreferences() async {
    await sharedPreferencesHelper.init();
    // Perform asynchronous work first
    String tempUserID = await sharedPreferencesHelper.getUserID() ?? '';
    String tempEmail = await sharedPreferencesHelper.getEmail() ?? "";

    // Update the state synchronously inside setState()
    setState(() {
      userID = tempUserID;
      print("id $userID");
      // email = tempEmail;
      // tProfileSubHeading = email;
      // print("email $email");
    });
  }

  Future<void> storeHistory(String userID, String date, String time, String topicID) async{
    try {
      if (await History().checkHistoryExists(userID, topicID)){
        String? historyId = await History().updateHistoryDateTime(userID,topicID, date, time);
        if (historyId != null) {
          print("History update successfully with ID: $historyId");
        } else {
          print("Error update history for topic");
        }      }
      else{
        String? historyId = await History().createHistory(userID, date, time,topicID);
        if (historyId != null) {
          print("History created successfully with ID: $historyId");
        } else {
          print("Error creating history for topic");
        }
      }
    } catch (e) {
      print('Error processing topics: $e');
    }
  }
  String getDate() {
    DateTime now = DateTime.now();
    return '${now.day}:${now.month}:${now.year}';
  }
  String getTime(){
    DateTime now = DateTime.now();
    return '${now.hour}:${now.minute}:${now.second}';
  }
  void _filterItems(String title) async {
    List<Topic> buffer1 = [];

    List<String> buffer2 = [];

    buffer1 = await Topic().searchTopicByTitle(_searchController.text);

    for (var topicData in buffer1) {
      String userID = topicData.userID;
      if (userID != null){
        String? name = await(User().getEmailByID(userID));
        buffer2.add(name!);
      }
    }
    setState(() {
      userNames  = buffer2;
      _filteredItems = buffer1;
    });
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _filteredItems = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(74, 89, 255,1),
        title: Text('Home'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      prefixIcon: Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: _clearSearch,
                            )
                          : null,
                    ),
                    onChanged: _filterItems,
                  ),
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: _clearSearch,
                  child: Text('Cancel'),
                ),
              ],
            ),
          ),SizedBox(height: 10,),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredItems.length,
              itemBuilder: (context, index) {
                final filteredItem = _filteredItems[index];
                final userName = userNames[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(filteredItem.userID),
                  ),
                  title: Text(filteredItem.title),
                  subtitle: Text(userName),
                  trailing: Text(filteredItem.numberFlashcard.toString()),
                  onTap: () {
                    storeHistory(userID, getDate(), getTime(), filteredItem.topicID);
                    Get.to(HomeScreenModes(title: filteredItem.title, date: filteredItem.date, topicID: filteredItem.topicID, active: filteredItem.active, userID: filteredItem.userID, folderId: ""));
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
