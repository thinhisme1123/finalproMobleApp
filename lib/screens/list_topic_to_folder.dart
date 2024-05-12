import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproject/home/home_modes_screen.dart';
import 'package:finalproject/screens/edit_folder_screen.dart';
import 'package:finalproject/screens/folder_detail.dart';
import 'package:flutter/material.dart';
import 'package:finalproject/model/Folder.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

import '../model/Topic.dart';

class ListTopic extends StatefulWidget {
  @override
  _ListTopicState createState() => _ListTopicState();
}

class _ListTopicState extends State<ListTopic> {
  List<Folder> _folders = [];
  List<Topic> _topics= [];
  bool _isLoadingTopic = true;
  bool _isLoadingFolder = true;

  @override
  void initState() {
    super.initState();
    _fetchFolders();
    _fetchTopics();
  }
  Future<void> _fetchTopics() async {
    List<Topic> topics = await Topic().getTopics();
    setState(() {
      _topics = topics;
      _isLoadingTopic = false;
    });
  }

  Future<void> _fetchFolders() async {
    List<Folder> folders = await Folder().getFolders();
    setState(() {
      _folders = folders;
      _isLoadingFolder = false;
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
          automaticallyImplyLeading: true,
          title: Text('Add Topic'),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(text: 'Created'),
              Tab(text: 'Learnt'),
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
                            print('Folder ${topic.title} dismissed');
                          }),
                          children: [
                            SlidableAction(
                              onPressed: (context) async {
                                // Handle folder deletion
                                await Topic().deleteTopicByID(topic.topicID);
                                _fetchFolders();
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
                            subtitle: Text(topic.topicID),
                            onTap: () {
                              print(index);
                              Get.to(HomeScreenModes(title: topic.title, date: topic.date, topicID: topic.topicID, active: topic.active,userID: topic.userID, folderId: topic.folderId));
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
                                  print('Folder ${folder.title} dismissed');
                                }),
                                children: [
                                  SlidableAction(
                                    onPressed: (context) async {
                                      // Handle folder deletion
                                      await Folder().deleteFolderByID(folder.folderId);
                                      _fetchFolders();
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
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}