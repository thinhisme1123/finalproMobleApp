import 'package:flutter/material.dart';


class FormAddVocab extends StatefulWidget {
  @override
  _FormAddVocabState createState() => _FormAddVocabState();
}

class _FormAddVocabState extends State<FormAddVocab> {
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
