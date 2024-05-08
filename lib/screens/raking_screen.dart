import 'package:flutter/material.dart';

class RankingScreen extends StatelessWidget {
  List<String> typeAchivement = ["Top 1 name", "Top 2 name", "Top 3 name"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ranking of this topic'),
      ),
      body: ListView.builder(
        itemCount: typeAchivement.length,
        itemBuilder: (context, index) {
          final achievement = typeAchivement[index];
          return ListTile(
            leading: CircleAvatar(
              child: Text('${index + 1}'),
            ),
            title: Text(achievement),
            onTap: () {

            },
          );
        },
      ),
    );
  }
}
