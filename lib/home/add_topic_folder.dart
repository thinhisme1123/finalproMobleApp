import 'package:flutter/material.dart';

class CustomBottomSheet extends StatefulWidget {
  @override
  _CustomBottomSheetState createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  bool _isBottomSheetVisible = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Text('Topics'),
            onTap: () {
              // Handle Topics option
              Navigator.pop(context); // Close the bottom sheet
            },
          ),
          ListTile(
            title: Text('Folder'),
            onTap: () {
              // Handle Folder option
              Navigator.pop(context); // Close the bottom sheet
            },
          ),
        ],
      ),
    );
  }
  
  void showBottomSheet() {
    setState(() {
      _isBottomSheetVisible = true;
    });
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return CustomBottomSheet();
      },
    ).whenComplete(() {
      setState(() {
        _isBottomSheetVisible = false;
      });
    });
  }
}