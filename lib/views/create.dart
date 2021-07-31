import 'package:flutter/material.dart';

class WriteView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text('Create Event'),
        centerTitle: true,
        elevation: 0,
      ),
    );
  }
}
