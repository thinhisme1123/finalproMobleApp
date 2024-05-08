import 'package:finalproject/screens/raking_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AchievementTopicScreen extends StatelessWidget {
  List<String> typeAchivement = ["Fastest and Acuracy", "Most time", "Shortest time"];


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
              //truyền thông tin topic theo loại trương ứng
              Get.to(RankingScreen());
            },
          );
        },
      ),
    );
  }
}
