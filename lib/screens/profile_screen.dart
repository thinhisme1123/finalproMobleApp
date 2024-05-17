import 'dart:io';

import 'package:finalproject/model/User.dart';
import 'package:finalproject/screens/achiement_screen.dart';
import 'package:finalproject/screens/signin_screen.dart';
import 'package:finalproject/screens/update.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:finalproject/auth/auth_service.dart';
import 'package:image_picker/image_picker.dart';

import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Helper/SharedPreferencesHelper.dart';

// Constants
const String tProfile = 'Profile';
const String tProfileImage = 'assets/images/profile.jpg';
late String tProfileHeading = 'John Doe';
late String tProfileSubHeading = 'john.doe@example.com';
const String tEditProfile = 'Edit Profile';
const double tDefaultSize = 16.0;
const Color tPrimaryColor = Colors.blue;
const Color tDarkColor = Colors.black;
String avatarUrl = "";

// Widgets
class ProfileMenuWidget extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color? textColor;
  final bool endIcon;
  final VoidCallback onPress;

  const ProfileMenuWidget({
    Key? key,
    required this.title,
    required this.icon,
    this.textColor,
    this.endIcon = true,
    required this.onPress,
  }) : super(key: key);

  @override
  State<ProfileMenuWidget> createState() => _ProfileMenuWidgetState();
}

class _ProfileMenuWidgetState extends State<ProfileMenuWidget> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: widget.onPress,
      leading: Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: tPrimaryColor.withOpacity(0.1),
        ),
        child: Icon(
          widget.icon,
          color: tPrimaryColor,
        ),
      ),
      title: Text(widget.title, style: TextStyle(color: widget.textColor)),
      trailing: widget.endIcon
          ? Icon(
        LineAwesomeIcons.angle_right,
        size: 20,
        color: Colors.grey[600],
      )
          : null,
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final SharedPreferencesHelper sharedPreferencesHelper =
  SharedPreferencesHelper();

  late Future<void> _loadingData;

  String userID = "";
  String email = "";
  String avatarUser = "";
  bool _loading = true;

  Future<void> _initSharedPreferences() async {
    await sharedPreferencesHelper.init();
    // Perform asynchronous work first
    String tempUserID = await sharedPreferencesHelper.getUserID() ?? '';
    String tempEmail = await sharedPreferencesHelper.getEmail() ?? "";
    String tempAvaterUser = await User().getAvatarByID(tempUserID) ??
        "https://firebasestorage.googleapis.com/v0/b/finalmobilecrossplatform.appspot.com/o/images%2Fprofile.jpg?alt=media&token=4106415a-c61f-4940-a0bc-9a19d18f5259";
    // Update the state synchronously inside setState()
    setState(() {
      userID = tempUserID;
      print("id $userID");
      email = tempEmail;
      tProfileSubHeading = email;
      print("email $email");
      avatarUser = tempAvaterUser;
      print("avatarUser:::::::::" + avatarUser);
    });
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    _initSharedPreferences().then((_){
      setState(() {
        _loading = false;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return _loading
        ? Center(child: CircularProgressIndicator())
        :Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(tProfile, style: Theme.of(context).textTheme.headline4),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(isDark ? LineAwesomeIcons.sun : LineAwesomeIcons.moon))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(tDefaultSize),
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image(image: NetworkImage(avatarUser))),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: tPrimaryColor),
                      child: IconButton(
                        icon: const Icon(
                          LineAwesomeIcons.alternate_pencil,
                          color: Colors.black,
                          size: 20,
                        ),
                        onPressed: _handleChangeAva,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(tProfileHeading,
                  style: Theme.of(context).textTheme.headline4),
              Text(tProfileSubHeading,
                  style: Theme.of(context).textTheme.bodyText2),
              const SizedBox(height: 20),

              /// -- BUTTON
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(() => UpdateScreen(
                      fullname: tProfileHeading,
                    ));
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: tPrimaryColor,
                      side: BorderSide.none,
                      shape: const StadiumBorder()),
                  child: const Text(tEditProfile,
                      style: TextStyle(color: tDarkColor)),
                ),
              ),
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 10),

              /// -- MENU
              ProfileMenuWidget(
                  title: "Settings",
                  icon: LineAwesomeIcons.cog,
                  onPress: () {}),
              ProfileMenuWidget(
                  title: "Achievement",
                  icon: LineAwesomeIcons.award,
                  onPress: () {
                    Get.to(
                        AchievementScreen());
                  }),
              const Divider(),
              const SizedBox(height: 10),
              ProfileMenuWidget(
                  title: "Information",
                  icon: LineAwesomeIcons.info,
                  onPress: () {}),
              ProfileMenuWidget(
                  title: "Logout",
                  icon: LineAwesomeIcons.alternate_sign_out,
                  textColor: Colors.red,
                  endIcon: false,
                  onPress: () {
                    _showLogoutDialog();
                  }),
            ],
          ),
        ),
      ),
    );
  }

  _signout() async {
    await AuthSevice().signout();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  void _showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop('dialog');
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              _signout();
              Get.offAllNamed('/welcome');
              Navigator.of(context, rootNavigator: true).pop('dialog');
            },
            child: const Text("Logout"),
          ),
        ],
      ),
      barrierDismissible: true,
    );
  }

  void _handleChangeAva() {
    Get.dialog(AlertDialog(
      title: const Text("Choose your avatar"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop('dialog');
                ImagePicker imagePicker = ImagePicker();
                XFile? file =
                await imagePicker.pickImage(source: ImageSource.camera);
                if (file == null) return;
                String fileName =
                DateTime.now().millisecondsSinceEpoch.toString();
                Reference referenceImg = FirebaseStorage.instance.ref();
                Reference dirImg = referenceImg.child("images");
                Reference imgUpload = dirImg.child(fileName);

                try {
                  await imgUpload.putFile(File(file!.path));
                  avatarUrl = await imgUpload.getDownloadURL();
                  await User().changeUserData(userID, avatarUrl);
                  setState(() {
                    avatarUser = avatarUrl;
                  });
                } catch (e) {
                  e.printError();
                }
              },
              child: const Text("Take a photo")),
          TextButton(
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop('dialog');
                ImagePicker imagePicker = ImagePicker();
                XFile? file =
                await imagePicker.pickImage(source: ImageSource.gallery);
                if (file == null) return;
                String fileName =
                DateTime.now().millisecondsSinceEpoch.toString();
                Reference referenceImg = FirebaseStorage.instance.ref();
                Reference dirImg = referenceImg.child("images");
                Reference imgUpload = dirImg.child(fileName);

                try {
                  await imgUpload.putFile(File(file!.path));
                  avatarUrl = await imgUpload.getDownloadURL();
                  await User().changeUserData(userID, avatarUrl);
                  setState(() {
                    avatarUser = avatarUrl;
                  });
                } catch (e) {
                  e.printError();
                }
              },
              child: const Text("From your gallery")),
        ],
      ),
    ));
  }
}
