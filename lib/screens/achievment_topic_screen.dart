import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:finalproject/screens/raking_screen.dart';

class AchievementType {
  final String name;
  final String imagePath;

  AchievementType(this.name, this.imagePath);
}

class AchievementTopicScreen extends StatelessWidget {
  final List<AchievementType> typeAchievement = [
    AchievementType("Fastest and Accuracy", "../../assets/images/fastest.png"),
    AchievementType("Most time", "../../assets/images/mosttime.jpg"),
    AchievementType("Shortest time", "../../assets/images/shortest.png"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ranking of this topic'),
      ),
      body: ListView.builder(
        itemCount: typeAchievement.length,
        itemBuilder: (context, index) {
          final achievement = typeAchievement[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(achievement.imagePath),
            ),
            title: Text(achievement.name),
            onTap: () {
              // Pass the selected topic information
              Get.to(RankingScreen());
            },
          );
        },
      ),
    );
  }
}
