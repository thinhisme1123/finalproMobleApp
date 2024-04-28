import 'package:finalproject/screens/form_add_vocab.dart';
import 'package:flutter/material.dart';

class CreateFolderScreen extends StatefulWidget {
  @override
  _CreateFolderScreenState createState() => _CreateFolderScreenState();
}

class _CreateFolderScreenState extends State<CreateFolderScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = "";
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      // Save the topic data (title, englishWord, vietnameseMeaning)
      // You can implement logic to store this data in your app's storage
      // (e.g., database, shared preferences)
      print("Topic created: $_title");
      Navigator.pop(context); // Close the screen after saving
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Topic'),
        actions: [
          TextButton(
            onPressed: _handleSave,
            child: Text('Save', style: TextStyle(fontSize: 20,color: Colors.black),),
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
                    return 'Please enter a title for your topic.';
                  }
                  return null;
                },
                onSaved: (value) => setState(() => _title = value!),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
