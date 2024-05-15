import 'package:finalproject/model/Folder.dart';
import 'package:finalproject/screens/folder_detail.dart';
import 'package:finalproject/screens/folder_detail_afterCreate.dart';
import 'package:finalproject/screens/form_add_vocab.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Helper/SharedPreferencesHelper.dart';

class CreateFolderScreen extends StatefulWidget {
  @override
  _CreateFolderScreenState createState() => _CreateFolderScreenState();
}

class _CreateFolderScreenState extends State<CreateFolderScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = "";
  String _description = "";
  late String userID;
  late String email;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  List<Folder> _folders = [];

  final SharedPreferencesHelper sharedPreferencesHelper = SharedPreferencesHelper();

  void _initSharedPreferences() async {
    // Perform asynchronous work outside of setState
    String tempUserID = await sharedPreferencesHelper.getUserID() ?? '';
    String tempEmail = await sharedPreferencesHelper.getEmail() ?? "";

    // Update the state synchronously inside setState
    setState(() {
      userID = tempUserID;
      print("id $userID");
      email = tempEmail;
      print("email $email");
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initSharedPreferences();
  }

  void _handleSave() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        String? folderId = await Folder().createFolder(
            _title, _description, userID);

        if (folderId != null) {
          Folder? folder = await Folder().getFolderByID(folderId);
          if (folder != null) {
            Get.off(FolderDetailScreen(folder: folder));
          } else {
            print("Error: Folder not found with ID $folderId");
          }
        } else {
          print("Error: Failed to create folder");
        }
      } catch (e) {
        print("Error creating folder: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(74, 89, 255,1),
        title: Text('Create Folder'),
        actions: [
          TextButton(
            onPressed: _handleSave,
            child: Text(
              'Save',
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Folder Title',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a title for your folder name.';
                  }
                  return null;
                },
                onSaved: (value) => setState(() => _title = value!),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a description for your Folder.';
                  }
                  return null;
                },
                onSaved: (value) => setState(() => _description = value!),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
