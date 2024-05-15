import 'package:finalproject/home/home_screen.dart';
import 'package:finalproject/model/Folder.dart';
import 'package:finalproject/screens/list_topic_to_folder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

import '../model/Topic.dart';

class FolderDetailScreen extends StatefulWidget {
  final Folder folder;

  FolderDetailScreen({required this.folder});

  @override
  _FolderDetailScreenState createState() => _FolderDetailScreenState();
}

class _FolderDetailScreenState extends State<FolderDetailScreen> {
  List<Topic> topics = [];

  bool _isLoadingFolder = true;
  Future<void> fetchTopics(String userID) async {
    List<Topic> _topics = await Topic().getTopicsByFolderID(widget.folder.folderId);
    setState(() {
      topics = _topics;
      _isLoadingFolder = false;
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  '${widget.folder.title}',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
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
                            Get.to(ListTopic(folderID: widget.folder.folderId));
                          },
                          child: Text('Add New Topic'),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                  itemCount: topics.length,
                  itemBuilder: (context, index) {
                    Topic topic = topics[index];
                    return Padding(
                      padding:
                      const EdgeInsets.symmetric(vertical: 8.0),
                      child: Slidable(
                        key: Key(topic.title), // Set a unique key for each item
                        endActionPane:  ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) async {
                                // if (topic.userID == userID){
                                //   await Topic().deleteTopicByID(topic.topicID);
                                //   fetchTopics(userID);
                                //   print('Topic ${topic.title} deleted');
                                //   Fluttertoast.showToast(
                                //       msg: "Delete successfully",
                                //       toastLength: Toast.LENGTH_SHORT,
                                //       gravity: ToastGravity.CENTER,
                                //       timeInSecForIosWeb: 1,
                                //       backgroundColor: Colors.green,
                                //       textColor: Colors.white,
                                //       fontSize: 16.0
                                //   );
                                // }
                                // else{
                                //   Fluttertoast.showToast(
                                //       msg: "You don't have permission to delete this topic",
                                //       toastLength: Toast.LENGTH_SHORT,
                                //       gravity: ToastGravity.CENTER,
                                //       timeInSecForIosWeb: 2,
                                //       backgroundColor: Colors.red,
                                //       textColor: Colors.white,
                                //       fontSize: 16.0
                                //   );
                                // }
                              },
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Delete',
                            ),
                            SlidableAction(
                              onPressed: (context) {
                                // (topic.userID == userID) ? Get.to(EditTopicScreen(topicId: topic.topicID ,title: topic.title))
                                // : Fluttertoast.showToast(
                                //     msg: "You don't have permission to edit this topic",
                                //     toastLength: Toast.LENGTH_SHORT,
                                //     gravity: ToastGravity.CENTER,
                                //     timeInSecForIosWeb: 2,
                                //     backgroundColor: Colors.red,
                                //     textColor: Colors.white,
                                //     fontSize: 16.0);
                              },
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              icon: Icons.update,
                              label: 'Edit',
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
                                            // _names[index],
                                            'User name',
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
                              trailing: Text(
                                topic.numberFlashcard.toString(),
                                style: TextStyle(
                                  fontSize:
                                  15,
                                  color: Colors
                                      .black,
                                ),
                              ),
                              onTap: () {
                                // print(index);
                                // storeHistory(userID, getDate(), getTime(), topic.topicID);
                                // Get.to(HomeScreenModes(
                                //     title: topic.title,
                                //     date: topic.date,
                                //     topicID: topic.topicID,
                                //     active: topic.active,
                                //     userID: topic.userID,
                                //     folderId: ""));
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
          ),
        ],
      ),
    );
  }
}
