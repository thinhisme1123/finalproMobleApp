import 'package:flutter/material.dart';

class UpdateScreen extends StatefulWidget {
  final fullname;
  final email;

  const UpdateScreen({Key? key, required this.fullname,required this.email}) : super(key: key);

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {

  TextEditingController fullnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    fullnameController.text = widget.fullname;
    emailController.text = widget.email;
    super.initState();
  }

  @override
  void dispose() {
    fullnameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Update Your Profile',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: fullnameController,
              decoration: InputDecoration(
                labelText: "Full name",
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
              ),
            ),
            // const SizedBox(height: 20),
            // TextFormField(
            //   decoration: InputDecoration(
            //     labelText: 'Phone Number',
            //     prefixIcon: Icon(Icons.phone),
            //   ),
            // ),
            // const SizedBox(height: 20),
            // TextFormField(
            //   obscureText: true,
            //   decoration: InputDecoration(
            //     labelText: 'Password',
            //     prefixIcon: Icon(Icons.lock),
            //   ),
            // ),
            const SizedBox(height: 20),
            ElevatedButton(
            onPressed: () {
              // Your update logic here (e.g., call an API to update user info)
              // update data to DB
              
              print("Update profile information");
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF007BFF), // Adjust to your desired color
              foregroundColor: Colors.white,
              textStyle: const TextStyle(fontSize: 16.0), // Adjust font size as needed
              minimumSize: const Size(double.infinity, 50.0), // Full width, set height
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0), // Add rounded corners
              ),
            ),
            child: const Text('Update'),
          ),
          ],
        ),
      ),
    );
  }
}
