import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webmaster/data/events.dart';

class WriteAccess extends StatelessWidget {
  final Function callback;
  WriteAccess({required this.callback});
  @override
  Widget build(BuildContext context) {
    final events = Provider.of<EventModel>(context);
    return GestureDetector(
      onTap: () => callback(),
      child: Container(
          decoration: BoxDecoration(
            border: Border.all(
                color: events.writeAccess ? Colors.green : Colors.red),
            borderRadius: BorderRadius.circular(30),
          ),
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Icon(events.writeAccess ? Icons.lock_open : Icons.lock,
              color: events.writeAccess ? Colors.green : Colors.red)),
    );
  }
}

class ServerStatus extends StatelessWidget {
  final Function callback;
  ServerStatus({required this.callback});
  @override
  Widget build(BuildContext context) {
    final events = Provider.of<EventModel>(context);
    return GestureDetector(
      onTap: () => callback(),
      child: Container(
          decoration: BoxDecoration(
            border: Border.all(
                color: events.serverStatus ? Colors.green : Colors.yellow),
            borderRadius: BorderRadius.circular(30),
          ),
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Icon(events.serverStatus ? Icons.wifi : Icons.warning,
              color: events.serverStatus ? Colors.green : Colors.yellow)),
    );
  }
}
