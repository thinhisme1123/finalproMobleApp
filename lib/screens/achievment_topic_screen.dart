import 'package:finalproject/model/Type_Achievement.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:finalproject/screens/raking_screen.dart';

import '../model/Quizz_Achievement.dart';
import '../model/User.dart';

class AchievementType extends StatefulWidget {
  final String type;
  final String userID;
  final String topicID;

  const AchievementType(
      {Key? key,
        required this.type,
        required this.userID,
        required this.topicID})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => AchievementTopicScreen();
}

class AchievementTopicScreen extends State<AchievementType> {
  List<Quizz_Achievement> Qachievements = [];
  List<Type_Achievement> Tachievements = [];
  List<Map<String, String>> shortest = [];
  List<Map<String, String>> mostcorrect = [];
  List<Map<String, String>> mosttime = [];
  String shortestEmail = "";
  String mostcorrectEmail = "";
  String mostimeEmail = "";
  late String type;

  @override
  void initState() {
    super.initState();
    type = widget.type;
    loadAchievements();
  }

  Future<void> loadAchievements() async {
    try {
      if (type == "Quizz"){
        List<Quizz_Achievement> loadedAchievements = await Quizz_Achievement().loadByTopicID(widget.topicID);
        Qachievements = loadedAchievements;
        String buffer1 = await User().getEmailByID(Qachievements[0].shortest['UserID']) ?? "";
        String buffer2 = await User().getEmailByID(Qachievements[0].mostTime['UserID']) ?? "";
        String buffer3 = await User().getEmailByID(Qachievements[0].mostCorrect['UserID']) ?? "";
        setState(() {
          shortestEmail = (buffer1 == "") ? "No result": buffer1;
          mostimeEmail = (buffer2 == "") ? "No result": buffer2;
          mostcorrectEmail = (buffer3 == "") ? "No result": buffer3;
        });

      }
      else{
        List<Type_Achievement> loadedAchievements = await Type_Achievement().loadByTopicID(widget.topicID);
        Tachievements = loadedAchievements;
        String buffer1 = await User().getEmailByID(Tachievements[0].shortest['UserID']) ?? "";
        String buffer2 = await User().getEmailByID(Tachievements[0].mostTime['UserID']) ?? "";
        String buffer3 = await User().getEmailByID(Tachievements[0].mostCorrect['UserID']) ?? "";
        setState(() {
          shortestEmail = buffer1;
          mostimeEmail = buffer2;
          mostcorrectEmail = buffer3;
        });
      }
    } catch (e) {
      print("Error loading achievements: $e");
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ranking of this topic'),
      ),
      body: ListView.builder(
        itemCount: (type == "Quizz") ? Qachievements.length : Tachievements.length,
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: CircleAvatar(
                  child: Icon(Icons.account_circle),
                ),
                title: Text('Shortest: $shortestEmail'),
                onTap: () {
                  // Handle when the user taps on the ListTile
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  child: Icon(Icons.account_circle),
                ),
                title: Text('Most Correct: $mostcorrectEmail'),
                onTap: () {
                  // Handle when the user taps on the ListTile
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  child: Icon(Icons.account_circle),
                ),
                title: Text('Most Time: $mostimeEmail'),
                onTap: () {
                  // Handle when the user taps on the ListTile
                },
              ),
            ],
          );
        },
      )
    );
  }}