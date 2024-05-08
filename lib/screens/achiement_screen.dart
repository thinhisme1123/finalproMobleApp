import 'package:flutter/material.dart';

class AchievementScreen extends StatelessWidget {
  final List<Achievement> userAchievements;

  AchievementScreen({required this.userAchievements});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Achievements'),
      ),
      body: ListView.builder(
        itemCount: userAchievements.length,
        itemBuilder: (context, index) {
          final achievement = userAchievements[index];
          return ListTile(
            leading: CircleAvatar(
              child: Text('${index + 1}'),
            ),
            title: Text(achievement.nameTopic),
            subtitle: Text(achievement.description),
          );
        },
      ),
    );
  }
}

class Achievement {
  final String nameTopic;
  final String description;

  Achievement({required this.nameTopic, required this.description});
}