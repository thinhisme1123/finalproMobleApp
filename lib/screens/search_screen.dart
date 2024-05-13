import 'package:flutter/material.dart';

import '../model/Topic.dart';
import '../model/User.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {


  late List<Topic> topics =[];

  List<Topic> _filteredItems = [];

  // List<Topic> buffer = [];

  List<String> userNames = [];

  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }


  void _filterItems(String title) async {
    List<Topic> buffer1 = [];

    List<String> buffer2 = [];

    buffer1 = await Topic().searchTopicByTitle(_searchController.text);

    for (var topicData in buffer1) {
      String userID = topicData.userID;
      if (userID != null){
        String? name = await(User().getEmailByID(userID));
        buffer2.add(name!);
      }
    }
    setState(() {
      userNames  = buffer2;
      _filteredItems = buffer1;
    });
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _filteredItems = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      prefixIcon: Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: _clearSearch,
                            )
                          : null,
                    ),
                    onChanged: _filterItems,
                  ),
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: _clearSearch,
                  child: Text('Cancel'),
                ),
              ],
            ),
          ),SizedBox(height: 10,),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredItems.length,
              itemBuilder: (context, index) {
                final filteredItem = _filteredItems[index];
                final userName = userNames[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(filteredItem.userID),
                  ),
                  title: Text(filteredItem.title),
                  subtitle: Text(userName),
                  trailing: Text(filteredItem.numberFlashcard.toString()),
                  onTap: () {
                    
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
