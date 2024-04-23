import 'package:flutter/material.dart';


class LibraryScreen extends StatefulWidget {
  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
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
            // Contents for the 'Topics' tab
            Container(
              child: Center(
                child: Text('Topics Content'),
              ),
            ),
            // Contents for the 'Folder' tab
            Container(
              child: Center(
                child: Text('Folder Content'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
