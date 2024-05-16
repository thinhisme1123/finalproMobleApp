import 'package:finalproject/home/home_screen.dart';
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
      if (type == "Quizz") {
        List<Quizz_Achievement> loadedAchievements =
            await Quizz_Achievement().loadByTopicID(widget.topicID);
        Qachievements = loadedAchievements;
        String buffer1 =
            await User().getEmailByID(Qachievements[0].shortest['UserID']) ??
                "";
        String buffer2 =
            await User().getEmailByID(Qachievements[0].mostTime['UserID']) ??
                "";
        String buffer3 =
            await User().getEmailByID(Qachievements[0].mostCorrect['UserID']) ??
                "";
        setState(() {
          shortestEmail = (buffer1 == "") ? "No result" : buffer1;
          mostimeEmail = (buffer2 == "") ? "No result" : buffer2;
          mostcorrectEmail = (buffer3 == "") ? "No result" : buffer3;
        });
      } else {
        List<Type_Achievement> loadedAchievements =
            await Type_Achievement().loadByTopicID(widget.topicID);
        Tachievements = loadedAchievements;
        String buffer1 =
            await User().getEmailByID(Tachievements[0].shortest['UserID']) ??
                "";
        String buffer2 =
            await User().getEmailByID(Tachievements[0].mostTime['UserID']) ??
                "";
        String buffer3 =
            await User().getEmailByID(Tachievements[0].mostCorrect['UserID']) ??
                "";
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
          leading: IconButton(onPressed: () {
            print('back');
            Get.offAll(HomeScreen(indexLibrary: 0,));
          }, icon: Icon(Icons.arrow_back)),
        ),
        backgroundColor: Color.fromRGBO(246, 247, 251, 1),
        body: Container(
          // color: Color.fromRGBO(246, 247, 251,1),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount:
                  (type == "Quizz") ? Qachievements.length : Tachievements.length,
              itemBuilder: (context, index) {
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
                        // title: Text('Shortest: $shortestEmail'),
                        title: Text(
                          'Topic Name',
                          style: TextStyle(
                            fontSize: 18, // Adjust the font size as needed
                            fontWeight: FontWeight.bold, // Apply bold font weight
                            color: Colors.black, // Change the text color
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10,),
                            Text(
                              'Shortest Time',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 10,),
                            Text(
                              'Achivement Type',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 40),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            'https://img.freepik.com/free-psd/3d-illustration-person-with-sunglasses_23-2149436188.jpg?w=740&t=st=1715584089~exp=1715584689~hmac=19c5214fff7fd007e469f8c88727ac4d0bd3ad37aeb40473d419d06744bf17de'),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 10),
                                        child: Text(
                                          "$shortestEmail",
                                          style: TextStyle(
                                            fontSize:
                                                14, // Adjust the font size as needed
                                            color: Colors
                                                .black, // Change the text color
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          // Xử lý khi người dùng nhấn vào ListTile
                        },
                      ),
                    ),
                    SizedBox(height: 20,),
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
                        // title: Text('Shortest: $shortestEmail'),
                        title: Text(
                          'Topic Name',
                          style: TextStyle(
                            fontSize: 18, // Adjust the font size as needed
                            fontWeight: FontWeight.bold, // Apply bold font weight
                            color: Colors.black, // Change the text color
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10,),
                            Text(
                              'Most Time',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 10,),
                            Text(
                              'Achivement Type',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 40),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            'https://img.freepik.com/free-psd/3d-illustration-person-with-sunglasses_23-2149436188.jpg?w=740&t=st=1715584089~exp=1715584689~hmac=19c5214fff7fd007e469f8c88727ac4d0bd3ad37aeb40473d419d06744bf17de'),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 10),
                                        child: Text(
                                          "$mostimeEmail",
                                          style: TextStyle(
                                            fontSize:
                                                14, // Adjust the font size as needed
                                            color: Colors
                                                .black, // Change the text color
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          // Xử lý khi người dùng nhấn vào ListTile
                        },
                      ),
                    ),
                    SizedBox(height: 20,),
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
                        // title: Text('Shortest: $shortestEmail'),
                        title: Text(
                          'Topic Name',
                          style: TextStyle(
                            fontSize: 18, // Adjust the font size as needed
                            fontWeight: FontWeight.bold, // Apply bold font weight
                            color: Colors.black, // Change the text color
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10,),
                            Text(
                              'Most Correct',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 10,),
                            Text(
                              'Achivement Type',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 40),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            'https://img.freepik.com/free-psd/3d-illustration-person-with-sunglasses_23-2149436188.jpg?w=740&t=st=1715584089~exp=1715584689~hmac=19c5214fff7fd007e469f8c88727ac4d0bd3ad37aeb40473d419d06744bf17de'),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 10),
                                        child: Text(
                                          "$mostcorrectEmail",
                                          style: TextStyle(
                                            fontSize:
                                                14, // Adjust the font size as needed
                                            color: Colors
                                                .black, // Change the text color
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          // Xử lý khi người dùng nhấn vào ListTile
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ));
  }
}
