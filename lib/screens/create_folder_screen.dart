import 'package:finalproject/model/Folder.dart';
import 'package:finalproject/screens/folder_detail.dart';
import 'package:finalproject/screens/folder_detail_afterCreate.dart';
import 'package:finalproject/screens/form_add_vocab.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CreateFolderScreen extends StatefulWidget {
  @override
  _CreateFolderScreenState createState() => _CreateFolderScreenState();
}

class _CreateFolderScreenState extends State<CreateFolderScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = "";
  String _description = "";
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  List<Folder> _folders = [];

  Future<void> _fetchFolders() async {
    List<Folder> folders = await Folder().getFolders();
    setState(() {
      _folders = folders;
    });
  }
  void _handleSave() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        String? errorMessage = await Folder().createFolder(_title,_description);

        if (errorMessage == null) {
          List<Folder> folders = await Folder().getFolders();
          Folder newFolder = folders.last; 

          print("Folder created: ${newFolder}");
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => FolderDetailAfterCreate(folder: newFolder)),
          );
        } else {
          print(errorMessage);
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
