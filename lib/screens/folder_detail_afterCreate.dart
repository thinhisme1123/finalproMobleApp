import 'package:finalproject/home/home_screen.dart';
import 'package:finalproject/model/Folder.dart';
import 'package:finalproject/screens/library_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FolderDetailAfterCreate extends StatefulWidget {
  final Folder folder;

  FolderDetailAfterCreate({required this.folder});

  @override
  _FolderDetailAfterCreateState createState() => _FolderDetailAfterCreateState();
}

class _FolderDetailAfterCreateState extends State<FolderDetailAfterCreate> {
  List<String> topics = []; // Replace this with your actual topics data

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.folder.title),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.off(() => HomeScreen(indexLibrary: 1,));
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //       builder: (context) => HomeScreen()),
            // );
          },
        ),
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
            child: topics.isEmpty
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
                        title: Text(topics[index]),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
