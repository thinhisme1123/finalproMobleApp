import 'package:finalproject/home/home_screen.dart';
import 'package:finalproject/model/Folder.dart';
import 'package:finalproject/screens/list_topic_to_folder.dart';
import 'package:flutter/material.dart';
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
                print("add topic this folder");
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
                      return ListTile(
                        // title: Text(topics[index]),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
