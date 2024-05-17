import 'package:flutter/material.dart';
import '../Helper/SharedPreferencesHelper.dart';
import '../model/Type_Achievement.dart';
import '../model/Quizz_Achievement.dart';
import '../model/Topic.dart';

class AchievementScreen extends StatefulWidget {
  @override
  State<AchievementScreen> createState() => _AchievementScreenState();
}

class _AchievementScreenState extends State<AchievementScreen> {
  final SharedPreferencesHelper sharedPreferencesHelper = SharedPreferencesHelper();
  late String userID;
  late String email;
  bool loading = true;
  List<Map<String, dynamic>> achievements = [];

  @override
  void initState() {
    super.initState();
    _initSharedPreferences().then((_) {
      loadAchievements();
    });
  }

  Future<void> _initSharedPreferences() async {
    await sharedPreferencesHelper.init();
    String tempUserID = await sharedPreferencesHelper.getUserID() ?? '';
    String tempEmail = await sharedPreferencesHelper.getEmail() ?? '';

    setState(() {
      userID = tempUserID;
      email = tempEmail;
      print("id $userID");
    });
  }

  Future<void> loadAchievements() async {
    try {
      List<Map<String, dynamic>> typeAchievements = await Type_Achievement().loadByUserID(userID);
      List<Map<String, dynamic>> quizzAchievements = await Quizz_Achievement().loadByUserID(userID);

      typeAchievements = typeAchievements.map((achievement) {
        return {
          'source': 'Type',
          'data': achievement,
        };
      }).toList();

      quizzAchievements = quizzAchievements.map((achievement) {
        return {
          'source': 'Quizz',
          'data': achievement,
        };
      }).toList();

      List<Map<String, dynamic>> combinedAchievements = [...typeAchievements, ...quizzAchievements];
      combinedAchievements.sort((a, b) {
        return a['data']['topicID'].compareTo(b['data']['topicID']);
      });

      List<Map<String, dynamic>> achievementsWithTitle = [];

      for (var achievement in combinedAchievements) {
        String topicID = achievement['data']['topicID'];
        String? title = await Topic().getTitleByID(topicID);
        if (title != null) {
          achievement['data']['title'] = title;
        }
        achievementsWithTitle.add(achievement);
      }

      setState(() {
        achievements = achievementsWithTitle;
        loading = false;
      });
    } catch (e) {
      print("Error loading achievements: $e");
      setState(() {
        loading = false;
      });
    }
  }

  String getAchievementResultText(String type, int result) {
    switch (type) {
      case 'Shortest':
        return 'The shortest time to answer: ' + formatSeconds(result);
      case 'MostTime':
        return 'Number of times studied: $result';
      case 'MostCorrect':
        return 'Number of answers: $result';
      default:
        return 'Unknown Result';
    }
  }

  String formatSeconds(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;

    String formattedTime = '';

    if (hours > 0) {
      formattedTime += '$hours' + 'h';
    }

    if (minutes > 0) {
      formattedTime += ' $minutes' + 'm';
    }

    if (remainingSeconds > 0) {
      formattedTime += ' $remainingSeconds' + 's';
    }

    return formattedTime.trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Achievements'),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.only(right: 16, left: 16),
        child: ListView.builder(
          itemCount: achievements.length,
          itemBuilder: (context, index) {
            Map<String, dynamic> achievement = achievements[index]['data'];
            String source = achievements[index]['source'];
            String title = achievement['title'] ?? 'Unknown Title';
            Map<String, dynamic> achievementData = achievement['achievement'];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListTile(
                    title: Text(
                      'Topic: $title',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    leading: CircleAvatar(
                      child: Text('${index + 1}'),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Text(
                          'Achievement: ${achievement['type']}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '${getAchievementResultText(achievement['type'], achievementData['Result'])}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Test Mode: $source',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          // 'User ID: ${achievementData['UserID']}',
                          "Email: $email",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15),
              ],
            );
          },
        ),
      ),
    );
  }
}
