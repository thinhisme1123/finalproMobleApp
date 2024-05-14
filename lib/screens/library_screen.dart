import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproject/home/home_modes_screen.dart';
import 'package:finalproject/screens/edit_folder_screen.dart';
import 'package:finalproject/screens/folder_detail.dart';
import 'package:flutter/material.dart';
import 'package:finalproject/model/Folder.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import '../Helper/SharedPreferencesHelper.dart';

import '../model/History.dart';
import '../model/Topic.dart';
import '../model/User.dart';

class LibraryScreen extends StatefulWidget {
  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final SharedPreferencesHelper sharedPreferencesHelper = SharedPreferencesHelper();
  List<Folder> _folders = [];
  List<Topic> _topics= [];
  List<String> _names =[];
  bool _isLoadingTopic = true;
  bool _isLoadingFolder = true;
  late String userID;
  @override
  @override

  @override
  void initState() {
    super.initState();
    _initSharedPreferences().then((_) {
      fetchTopics(userID);
      fetchFolders();
    });
  }
  String getDate() {
    DateTime now = DateTime.now();
    return '${now.day}:${now.month}:${now.year}';
  }
  String getTime(){
    DateTime now = DateTime.now();
    return '${now.hour}:${now.minute}:${now.second}';
  }
  Future<void> fetchTopics(String userID) async {
    try {
      List<Map<String, dynamic>> openedTopics = await History().getUserOpenedTopics(userID);
      print("Success");
      for (var topicData in openedTopics) {
        String topicID = topicData['topicID'];
        print("topic id $topicID");
        Topic? topic = await Topic().getTopicByID(topicID);
        if (topic != null){
          _topics.add(topic);
          String? name = await(User().getEmailByID(userID));
          _names.add(name!);
        }
      };
      setState(() {
        _isLoadingTopic = false;
      });
    } catch (e) {
      print('Error processing topics: $e');
    }
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

  // Future<void> _fetchTopics() async {
  //   List<Topic> topics = await Topic().getTopics();
  //   setState(() {
  //     _topics = topics;
  //     _isLoadingTopic = false;
  //   });
  // }

  Future<void> fetchFolders() async {
    List<Folder> folders = await Folder().getFoldersByUserID(userID);
    setState(() {
      _folders = folders;
      _isLoadingFolder = false;
    });
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


  void _addFolder(Folder folder) {
    setState(() {
      _folders.add(folder);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Specify the number of tabs
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Library'),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(text: 'Topics'),
              Tab(text: 'Folder'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _isLoadingTopic
                ? Center(child: CircularProgressIndicator())
                :Container(
              color: Color(0xfff6f7fb), // Background color for the container
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _topics.length > 0
                    ? ListView.builder(
                  itemCount: _topics.length,
                  itemBuilder: (context, index) {
                    Topic topic = _topics[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Slidable(
                        key: Key(topic
                            .title), // Set a unique key for each item
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          dismissible: DismissiblePane(onDismissed: () async {
                            // Handle topic deletion
                            await Topic().deleteTopicByID(topic.topicID);
                            fetchTopics(userID);
                            print('Topic ${topic.title} dismissed');
                          }),
                          children: [
                            SlidableAction(
                              onPressed: (context) async {
                                // Handle folder deletion
                                await Topic().deleteTopicByID(topic.topicID);
                                fetchTopics(userID);
                                print('Topic ${topic.title} deleted');
                              },
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Delete',
                            ),
                            SlidableAction(
                              onPressed: (context) {
                                // Handle folder edit
                                // Get.to(HomeScreenModes(title: topic.title, date: topic.date, topicID: topic.topicID, active: topic.active,userID: topic.userID, folderId: topic.folderId));
                              },
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              icon: Icons.update,
                              label: 'Edit',
                            ),
                          ],
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: ListTile(
                            leading: Icon(Icons.newspaper),
                            title: Text(topic.title),
                            subtitle: Text(_names[index]),
                            onTap: () {
                              print(index);
                              storeHistory(userID, getDate(), getTime(), topic.topicID);
                              Get.to(HomeScreenModes(title: topic.title, date: topic.date, topicID: topic.topicID, active: topic.active,userID: topic.userID, folderId: ""));
                            },
                          ),
                        ),
                      ),
                    );
                  },
                )
                    : Center(child: Text("You don't have any topic")),
              ),
            ),
            _isLoadingFolder
                ? Center(child: CircularProgressIndicator())
                :Container(
              color: Color(0xfff6f7fb), // Background color for the container
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _folders.length > 0
                    ? ListView.builder(
                        itemCount: _folders.length,
                        itemBuilder: (context, index) {
                          Folder folder = _folders[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Slidable(
                              key: Key(folder
                                  .title), // Set a unique key for each item
                              endActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                dismissible: DismissiblePane(onDismissed: () async {
                                  // Handle folder deletion
                                  await Folder().deleteFolderByID(folder.folderId);
                                  fetchFolders();
                                  print('Folder ${folder.title} dismissed');
                                }),
                                children: [
                                  SlidableAction(
                                    onPressed: (context) async {
                                      // Handle folder deletion
                                      await Folder().deleteFolderByID(folder.folderId);
                                      fetchFolders();
                                      print('Folder ${folder.title} deleted');
                                    },
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete,
                                    label: 'Delete',
                                  ),
                                  SlidableAction(
                                    onPressed: (context) {
                                      // Handle folder edit
                                      Get.to(EditFolderScreen(title: folder.title, desc: folder.description, id: folder.folderId));
                                    },
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    icon: Icons.update,
                                    label: 'Edit',
                                  ),
                                ],
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: ListTile(
                                  leading: Icon(Icons.folder),
                                  title: Text(folder.title),
                                  subtitle: Text(folder.description),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              FolderDetailScreen(
                                                  folder: folder)),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    :Center(child: Text("You don't have any folder")),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
