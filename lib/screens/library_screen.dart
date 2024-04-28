import 'package:flutter/material.dart';

class LibraryScreen extends StatefulWidget {
  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  int folderLeng = 1;
  String folderName = "Important Vocab";

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
                child: ListView.builder(
                  itemCount: folderLeng,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white, // Background color for each ListTile
                        borderRadius: BorderRadius.circular(
                            8.0), // Border radius for rounded corners
                      ),
                      child: ListTile(
                        leading: Icon(Icons.folder),
                        title: Text(folderName),
                        onTap: () {
                          
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
