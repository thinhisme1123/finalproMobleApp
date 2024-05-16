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
      body: Padding(
        padding: const EdgeInsets.only(right: 16,left: 16),
        child: ListView.builder(
          itemCount: userAchievements.length,
          itemBuilder: (context, index) {
            final achievement = userAchievements[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.grey, // Màu viền
                      width: 1.0, // Độ rộng của viền
                    ),
                    borderRadius:
                        BorderRadius.circular(10.0), // Góc bo tròn của viền
                  ),
                  child: ListTile(
                    title: Text(
                      'Topic Name',
                      style: TextStyle(
                        fontSize: 18, // Adjust the font size as needed
                        fontWeight: FontWeight.bold, // Apply bold font weight
                        color: Colors.black, // Change the text color
                      ),
                    ),
                    leading: CircleAvatar(
                      child: Text('${index + 1}'),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Shortest Time',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Achivement Type',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Achivement Type',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Achivement Type',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15,)
              ],
            );
          },
        ),
      ),
    );
  }
}

class Achievement {
  final String nameTopic;
  final String description;

  Achievement({required this.nameTopic, required this.description});
}
