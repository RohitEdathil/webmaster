import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webmaster/data/events.dart';

class WriteAccess extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final events = Provider.of<EventModel>(context);
    return GestureDetector(
      onTap: () => events.toggleWrite(),
      child: Container(
          decoration: BoxDecoration(
            border: Border.all(
                color: events.writeAccess ? Colors.green : Colors.red),
            borderRadius: BorderRadius.circular(30),
          ),
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
          child: Row(
            children: [
              Icon(events.writeAccess ? Icons.lock_open : Icons.lock,
                  color: events.writeAccess ? Colors.green : Colors.red),
              SizedBox(width: 5),
              Text(
                "Write",
                style: TextStyle(
                    color: events.writeAccess ? Colors.green : Colors.red),
              )
            ],
          )),
    );
  }
}
