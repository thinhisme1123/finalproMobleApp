import 'package:finalproject/screens/signin_screen.dart';
import 'package:finalproject/screens/update.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:finalproject/auth/auth_service.dart';

import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Constants
const String tProfile = 'Profile';
const String tProfileImage = 'assets/images/profile.jpg';
late String tProfileHeading = 'John Doe';
late String tProfileSubHeading = 'john.doe@example.com';
const String tEditProfile = 'Edit Profile';
const double tDefaultSize = 16.0;
const Color tPrimaryColor = Colors.blue;
const Color tDarkColor = Colors.black;


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
 late SharedPreferences _prefs;

 String userID ="";
 String email = "";

 void _initSharedPreferences() async {
   _prefs = await SharedPreferences.getInstance();
   setState(() {
     userID = _prefs.getString('userID') ?? '';
     print("id $userID");
     email = _prefs.getString("Email") ?? "";
     tProfileSubHeading = email;
     print("email $email");
   });
 }
 void initState() {
   // TODO: implement initState
   super.initState();
   _initSharedPreferences();
 }
 @override
 Widget build(BuildContext context) {
   var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
   return Scaffold(
     appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(tProfile, style: Theme.of(context).textTheme.headline4),
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
             /// -- IMAGE
             Stack(
               children: [
                 SizedBox(
                   width: 120,
                   height: 120,
                   child: ClipRRect(
                       borderRadius: BorderRadius.circular(100),
                       child: const Image(image: AssetImage(tProfileImage))),
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
                     child: const Icon(
                       LineAwesomeIcons.alternate_pencil,
                       color: Colors.black,
                       size: 20,
                     ),
                   ),
                 ),
               ],
             ),
             const SizedBox(height: 10),
             Text(tProfileHeading, style: Theme.of(context).textTheme.headline4),
             Text(tProfileSubHeading, style: Theme.of(context).textTheme.bodyText2),
             const SizedBox(height: 20),

             /// -- BUTTON
             SizedBox(
               width: 200,
               child: ElevatedButton(
                 onPressed: () {
                  Get.to(() =>  UpdateScreen(fullname: tProfileHeading, email: tProfileSubHeading,));
                 },
                 style: ElevatedButton.styleFrom(
                     backgroundColor: tPrimaryColor,
                     side: BorderSide.none,
                     shape: const StadiumBorder()),
                 child: const Text(tEditProfile, style: TextStyle(color: tDarkColor)),
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
                 onPress: () {}),
             ProfileMenuWidget(
                 title: "User Management",
                 icon: LineAwesomeIcons.user_check,
                 onPress: () {}),
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
                   Get.defaultDialog(
                     title: "LOGOUT",
                     titleStyle: const TextStyle(fontSize: 20),
                     content: const Padding(
                       padding: EdgeInsets.symmetric(vertical: 15.0),
                       child: Text("Are you sure, you want to Logout?"),
                     ),
                     confirm: Expanded(
                       child: ElevatedButton(
                         onPressed: () {
                            _signout();
                            Navigator.pop(context);
                         },
                         style: ElevatedButton.styleFrom(
                             backgroundColor: Colors.redAccent,
                             side: BorderSide.none),
                         child: const Text("Yes"),
                       ),
                     ),
                     cancel: OutlinedButton(
                         onPressed: () => Get.back(),
                         child: const Text("No")),
                   );
                 }),
           ],
         ),
       ),
     ),
   );
 }

 _signout() async {
     await AuthSevice().signout();
     Get.toNamed('/welcome');
 }
}
