import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproject/screens/folder_detail.dart';
import 'package:flutter/material.dart';
import 'package:finalproject/model/Folder.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class LibraryScreen extends StatefulWidget {
  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  List<Folder> _folders = [];

  @override
  void initState() {
    super.initState();
    _fetchFolders();
  }

  Future<void> _fetchFolders() async {
    List<Folder> folders = await Folder().getFolders();
    setState(() {
      _folders = folders;
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
          bottom: TabBar(
            tabs: [
              Tab(text: 'Topics'),
              Tab(text: 'Folder'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Container(
              child: Center(
                child: Text('Topics Content'),
              ),
            ),
            Container(
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
                                dismissible: DismissiblePane(onDismissed: () {
                                  // Handle folder deletion
                                  Folder().deleteFolder(folder.title);
                                  print('Folder ${folder.title} dismissed');
                                }),
                                children: [
                                  SlidableAction(
                                    onPressed: (context) {
                                      // Handle folder deletion
                                      Folder().deleteFolder(folder.title);
                                      print('Folder ${folder.title} deleted');
                                    },
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete,
                                    label: 'Delete',
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
