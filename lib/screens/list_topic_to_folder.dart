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

class ListTopic extends StatefulWidget {
  @override
  _ListTopicState createState() => _ListTopicState();
}

class _ListTopicState extends State<ListTopic> {
  final SharedPreferencesHelper sharedPreferencesHelper = SharedPreferencesHelper();

  List<Topic> _learnttopics = [];
  List<Topic> buffer = [];
  List<Topic> _createdtopics= [];
  bool _isLoadingCreatedTopic = true;
  bool _isLearntTopic = true;
  late String userID;

  @override
  void initState() {
    super.initState();
    _initSharedPreferences().then((_) {
      fetchCreatedTopics();
      fetchLearntTopics();
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

  Future<void> fetchCreatedTopics() async {
    List<Topic> topics = await Topic().getTopicsByUserID_NoFolderID(userID);
    setState(() {
      _createdtopics = topics;
      _isLoadingCreatedTopic = false;
    });
  }

  Future<void> fetchLearntTopics() async {
    try {
      List<Map<String, dynamic>> openedTopics = await History().getUserOpenedTopics_NoFolderID(userID);
      print("Success");
      for (var topicData in openedTopics) {
        String topicID = topicData['topicID'];
        print("topic id $topicID");
        Topic? topic = await Topic().getTopicByID(topicID);
        if (topic != null){
          buffer.add(topic);
        }
      }
      setState(() {
        _learnttopics = buffer;
        _isLearntTopic = false;
      });
    } catch (e) {
      print('Error processing topics: $e');
    }
  }


  // void _addFolder(Folder folder) {
  //   setState(() {
  //     _learnttopics.add(folder);
  //   });
  // }

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
            _isLoadingCreatedTopic
                ? Center(child: CircularProgressIndicator())
                :Container(
              color: Color(0xfff6f7fb), // Background color for the container
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _createdtopics.length > 0
                    ? ListView.builder(
                  itemCount: _createdtopics.length,
                  itemBuilder: (context, index) {
                    Topic topic = _createdtopics[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Slidable(
                        key: Key(topic
                            .title), // Set a unique key for each item
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          dismissible: DismissiblePane(onDismissed: () async {}),
                          children: [
                            SlidableAction(
                              onPressed: (context) async {},
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Add',
                            ),
                            // SlidableAction(
                            //   onPressed: (context) {
                            //   },
                            //   backgroundColor: Colors.green,
                            //   foregroundColor: Colors.white,
                            //   icon: Icons.update,
                            //   label: 'Edit',
                            // ),
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
                            onTap: () {},
                          ),
                        ),
                      ),
                    );
                  },
                )
                    : null,
              ),
            ),
            _isLearntTopic
                ? Center(child: CircularProgressIndicator())
                :Container(
              color: Color(0xfff6f7fb), // Background color for the container
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _learnttopics.length > 0
                    ? ListView.builder(
                        itemCount: _learnttopics.length,
                        itemBuilder: (context, index) {
                          Topic topic = _learnttopics[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Slidable(
                              key: Key(topic
                                  .title), // Set a unique key for each item
                              endActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                dismissible: DismissiblePane(onDismissed: () async {
                                }),
                                children: [
                                  SlidableAction(
                                    onPressed: (context) async {
                                    },
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete,
                                    label: 'Delete',
                                  ),
                                  SlidableAction(
                                    onPressed: (context) {
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
                                  leading: Icon(Icons.topic),
                                  title: Text(topic.title),
                                  subtitle: Text(topic.userID),
                                  onTap: () {}
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
