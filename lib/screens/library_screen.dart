import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproject/home/home_modes_screen.dart';
import 'package:finalproject/screens/edit_folder_screen.dart';
import 'package:finalproject/screens/folder_detail.dart';
import 'package:finalproject/screens/edit_topic_screen.dart';
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
  final SharedPreferencesHelper sharedPreferencesHelper =
      SharedPreferencesHelper();
  List<Folder> _folders = [];
  List<Topic> _topics = [];
  List<String> _names = [];
  bool _isLoadingTopic = true;
  bool _isLoadingFolder = true;
  late String userID;
  @override
  @override
  @override
  void initState() {
    super.initState();
    _initSharedPreferences().then((_) {
      // Sau khi userID được khởi tạo từ _initSharedPreferences(), gọi _fetchTopics
      _fetchTopics(userID);
      _fetchFolders();
    });
  }

  Future<void> _fetchTopics(String userID) async {
    try {
      List<Map<String, dynamic>> openedTopics =
          await History().getUserOpenedTopics(userID);
      print("Successsssssss");
      for (var topicData in openedTopics) {
        String topicID = topicData['topicID'];
        print("topic id $topicID");
        Topic? topic = await Topic().getTopicByID(topicID);
        if (topic != null) {
          _topics.add(topic);
          String? name = await (User().getEmailByID(userID));
          _names.add(name!);
        }
      }
      ;
      setState(() {
        _isLoadingTopic = false;
      });
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

  Future<void> _fetchFolders() async {
    List<Folder> folders = await Folder().getFolders();
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
          backgroundColor: Color.fromRGBO(74, 89, 255, 1),
          automaticallyImplyLeading: false,
          title: Text('Library'),
          centerTitle: true,
          bottom: TabBar(
            labelColor: Colors.white,
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
                : Container(
                    color:
                        Color(0xfff6f7fb), // Background color for the container
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: _topics.length > 0
                          ? ListView.builder(
                              itemCount: _topics.length,
                              itemBuilder: (context, index) {
                                Topic topic = _topics[index];
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Slidable(
                                    key: Key(topic
                                        .title), // Set a unique key for each item
                                    endActionPane: ActionPane(
                                      motion: const ScrollMotion(),
                                      dismissible: DismissiblePane(
                                          onDismissed: () async {
                                        // Handle topic deletion
                                        await Topic()
                                            .deleteTopicByID(topic.topicID);
                                        print('Topic ${topic.title} dismissed');
                                      }),
                                      children: [
                                        SlidableAction(
                                          onPressed: (context) async {
                                            // Handle folder deletion
                                            await Topic()
                                                .deleteTopicByID(topic.topicID);
                                            _fetchFolders();
                                            print(
                                                'Topic ${topic.title} deleted');
                                          },
                                          backgroundColor: Colors.red,
                                          foregroundColor: Colors.white,
                                          icon: Icons.delete,
                                          label: 'Delete',
                                        ),
                                        SlidableAction(
                                          onPressed: (context) {
                                            // Handle topic edit
                                            Get.to(EditTopicScreen(topicId: topic.topicID ,title: topic.title));

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
                                      height: 150,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors
                                              .black, // Set the color of the border
                                          width: 1.0,
                                        ),
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ListTile(
                                          title: Text(
                                            topic.title,
                                            style: TextStyle(
                                              fontSize:
                                                  18, // Adjust the font size as needed
                                              fontWeight: FontWeight
                                                  .bold, // Apply bold font weight
                                              color: Colors
                                                  .black, // Change the text color
                                            ),
                                          ),
                                          subtitle: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 50),
                                            child: Row(
                                              children: [
                                                CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                      'https://img.freepik.com/free-psd/3d-illustration-person-with-sunglasses_23-2149436188.jpg?w=740&t=st=1715584089~exp=1715584689~hmac=19c5214fff7fd007e469f8c88727ac4d0bd3ad37aeb40473d419d06744bf17de'),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  child: Text(
                                                    _names[index],
                                                    style: TextStyle(
                                                      fontSize:
                                                          14, // Adjust the font size as needed
                                                      color: Colors
                                                          .grey, // Change the text color
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          trailing: Text(
                                            "50 topics",
                                            style: TextStyle(
                                              fontSize:
                                                  15,
                                              color: Colors
                                                  .black,
                                            ),
                                          ),
                                          onTap: () {
                                            print(index);
                                            Get.to(HomeScreenModes(
                                                title: topic.title,
                                                date: topic.date,
                                                topicID: topic.topicID,
                                                active: topic.active,
                                                userID: topic.userID,
                                                folderId: topic.folderId));
                                          },
                                        ),
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
                : Container(
                    color:
                        Color(0xfff6f7fb), // Background color for the container
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: _folders.length > 0
                          ? ListView.builder(
                              itemCount: _folders.length,
                              itemBuilder: (context, index) {
                                Folder folder = _folders[index];
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Slidable(
                                    key: Key(folder
                                        .title), // Set a unique key for each item
                                    endActionPane: ActionPane(
                                      motion: const ScrollMotion(),
                                      dismissible: DismissiblePane(
                                          onDismissed: () async {
                                        // Handle folder deletion
                                        await Folder()
                                            .deleteFolderByID(folder.folderId);
                                        print(
                                            'Folder ${folder.title} dismissed');
                                      }),
                                      children: [
                                        SlidableAction(
                                          onPressed: (context) async {
                                            // Handle folder deletion
                                            await Folder().deleteFolderByID(
                                                folder.folderId);
                                            _fetchFolders();
                                            print(
                                                'Folder ${folder.title} deleted');
                                          },
                                          backgroundColor: Colors.red,
                                          foregroundColor: Colors.white,
                                          icon: Icons.delete,
                                          label: 'Delete',
                                        ),
                                        SlidableAction(
                                          onPressed: (context) {
                                            // Handle folder edit
                                            Get.to(EditFolderScreen(
                                                title: folder.title,
                                                desc: folder.description,
                                                id: folder.folderId));
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
                                        border: Border.all(
                                          color: Colors
                                              .black, // Set the color of the border
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
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
                          : null,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
