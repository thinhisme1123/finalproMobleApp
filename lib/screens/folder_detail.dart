import 'package:finalproject/home/home_screen.dart';
import 'package:finalproject/model/Folder.dart';
import 'package:finalproject/screens/list_topic_to_folder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../Helper/SharedPreferencesHelper.dart';
import '../home/home_modes_screen.dart';
import '../model/Topic.dart';
import '../model/User.dart';

class FolderDetailScreen extends StatefulWidget {
  final Folder folder;

  FolderDetailScreen({required this.folder});

  @override
  _FolderDetailScreenState createState() => _FolderDetailScreenState();
}

class _FolderDetailScreenState extends State<FolderDetailScreen> {
  List<Topic> topics = [];
  final SharedPreferencesHelper sharedPreferencesHelper =
      SharedPreferencesHelper();
  late String userID;
  List<String> _names = [];

  bool _isLoadingFolder = true;
  Future<void> fetchTopics(String userID) async {
    List<Topic> _topics =
        await Topic().getTopicsByFolderID(widget.folder.folderId);
    for (var topicData in _topics) {
      String topicID = topicData.topicID;
      print("topic id $topicID");
      Topic? topic = await Topic().getTopicByID(topicID);
      if (topic != null) {
        String? name = await (User().getEmailByID(topic.userID));
        _names.add(name!);
      }
    }
    setState(() {
      topics = _topics;
      _isLoadingFolder = false;
    });
    print(topics.length);
  }

  Future<void> _deleteTopic(String topicId) async {
    try {
      await Folder().deleteTopicFromFolder(widget.folder.folderId, topicId);
      setState(() {
        topics.removeWhere((topic) => topic.topicID == topicId);
      });
      print('Topic $topicId deleted');
    } catch (e) {
      print('Error deleting topic: $e');
    }
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

  void initState() {
    super.initState();
    _initSharedPreferences().then((_) {
      fetchTopics(userID);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.folder.title),
        actions: [
          IconButton(
              onPressed: () {
                Get.to(ListTopic(folderID: widget.folder.folderId));
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: _isLoadingFolder
          ? Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        '${widget.folder.title}',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${widget.folder.description}',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: topics.length < 1
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.folder_open,
                                size: 80,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'This folder doesn\'t have any topics yet.',
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Tap the button below to add a new topic.',
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  // Navigate to the create topic screen
                                  Get.to(ListTopic(
                                      folderID: widget.folder.folderId));
                                },
                                child: Text('Add New Topic'),
                              ),
                            ],
                          ),
                        )
                      : Padding(
                        padding: const EdgeInsets.only(right: 16, left:16),
                        child: ListView.builder(
                            itemCount: topics.length,
                            itemBuilder: (context, index) {
                              Topic topic = topics[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Slidable(
                                  key: Key(topic
                                      .title), // Set a unique key for each item
                                  endActionPane: ActionPane(
                                    motion: const ScrollMotion(),
                                    children: [
                                      SlidableAction(
                                        onPressed: (context) async {
                                          if (topic.userID == userID) {
                                            _deleteTopic(topic.topicID);
                                            print('Topic ${topic.title} deleted');
                                            Fluttertoast.showToast(
                                                msg: "Delete successfully",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.CENTER,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: Colors.green,
                                                textColor: Colors.white,
                                                fontSize: 16.0);
                                          }
                                          // Folder().deleteTopicFromFolder(widget.folder.folderId, topic.topicID);
                                          // setState(() {
                                          //   topics.removeAt(index); // Xoá mục khỏi danh sách
                                          // });
                                          // fetchTopics(userID); // Tả
                                        },
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white,
                                        icon: Icons.delete,
                                        label: 'Delete',
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    height: 160,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors
                                            .black, // Set the color of the border
                                        width: 1.0,
                                      ),
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8.0),
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
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${topic.numberFlashcard.toString()} words',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 40),
                                              child: Column(
                                                children: [
                                                  Row(
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
                                                          // 'User name',
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
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        onTap: () {
                                          print(index);
                                          print(index);
                                          Get.to(HomeScreenModes(
                                              title: topic.title,
                                              date: topic.date,
                                              topicID: topic.topicID,
                                              active: topic.active,
                                              userID: topic.userID,
                                              folderId: ""));
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                      ),
                ),
              ],
            ),
    );
  }
}
