import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final List<Map<String, dynamic>> comments = [
    {
      'username': 'quizlette22788555',
      'message': 'Hoa quả',
      'timeSince': '29 thuật ngữ',
    },
    {
      'username': 'quochanh_dle',
      'message': 'Hoa quả',
      'timeSince': '56 thuật ngữ',
    },
    {
      'username': 'ngocanh290507',
      'message': 'hoa quả',
      'timeSince': '20 thuật ngữ',
    },
  ];

  List<Map<String, dynamic>> _filteredItems = [];

  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredItems = comments;
  }

  void _filterItems(String query) {
    setState(() {
      //hand do search filter from database
    });
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _filteredItems = comments;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(74, 89, 255,1),
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
              itemCount: comments.length,
              itemBuilder: (context, index) {
                final comment = comments[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(comment['username'][0]),
                  ),
                  title: Text(comment['username']),
                  subtitle: Text(comment['message']),
                  trailing: Text(comment['timeSince']),
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
