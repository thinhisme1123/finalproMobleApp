import 'package:finalproject/model/Folder.dart';
import 'package:finalproject/screens/folder_detail.dart';
import 'package:finalproject/screens/folder_detail_afterCreate.dart';
import 'package:finalproject/screens/form_add_vocab.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditFolderScreen extends StatefulWidget {
  final String title;
  final String desc;

  const EditFolderScreen({Key? key, required this.title, required this.desc})
      : super(key: key);

  @override
  _EditFolderScreenState createState() => _EditFolderScreenState();
}

class _EditFolderScreenState extends State<EditFolderScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = "";
  String _description = "";

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _titleController.text = widget.title;
    _descriptionController.text = widget.desc;
  }

  void _handleSave() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {

        // Folder folder = Folder();
        // await folder.updateFolder(newTitle, newDescription, folderId);

      } catch (e) {
        print("Error creating folder: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Folder'),
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
                controller: _titleController,
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
                controller: _descriptionController,
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
