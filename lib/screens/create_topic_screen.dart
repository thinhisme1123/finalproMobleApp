import 'package:finalproject/screens/form_add_vocab.dart';
import 'package:flutter/material.dart';

class CreateTopic extends StatefulWidget {
  @override
  _CreateTopicState createState() => _CreateTopicState();
}

class _CreateTopicState extends State<CreateTopic> {
  final _formKey = GlobalKey<FormState>();
  String _title = "";
  List<String> _englishWords = []; // List to store English words
  List<String> _vietnameseMeanings = [];

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      // Save the topic data (title, englishWord, vietnameseMeaning)
      // You can implement logic to store this data in your app's storage
      // (e.g., database, shared preferences)
      print("Topic created: $_title ($_englishWords - $_vietnameseMeanings)");
      Navigator.pop(context); // Close the screen after saving
    }
  }

  void _addTerm() {
    setState(() {
      _englishWords.add("");
      _vietnameseMeanings.add("");
    });
  }

  void _removeTerm(int index) {
    if (_englishWords.length > 1) {
      // Prevent removing the last term
      setState(() {
        _englishWords.removeAt(index);
        _vietnameseMeanings.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Topic'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Topic Title',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a title for your topic.';
                  }
                  return null;
                },
                onSaved: (value) => setState(() => _title = value!),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(height: 10.0),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _englishWords.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    // Wrap each term in Dismissible
                    key: Key(UniqueKey().toString()), // Dismiss on swipe right
                    onDismissed: (direction) => _removeTerm(index),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'English Word',
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter an English word.';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) => setState(
                                      () => _englishWords[index] = value!),
                                ),
                                SizedBox(height: 10.0),
                                TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Vietnamese Meaning',
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter the Vietnamese meaning.';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) => setState(() =>
                                      _vietnameseMeanings[index] = value!),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10.0), // Add spacing between terms
                      ],
                    ),
                  );
                },
              ),
              SizedBox(height: 20.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _handleSave,
                  child: Text('Add Topic'),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTerm,
        child: Icon(Icons.add),
      ),
    );
  }
}
