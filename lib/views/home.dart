import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webmaster/components/write_access.dart';
import 'package:webmaster/data/events.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final events = Provider.of<EventModel>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0,
        actions: [WriteAccess()],
      ),
      body: Center(
        child: Text(events.ready ? "Ready" : "Not"),
      ),
    );
  }
}
