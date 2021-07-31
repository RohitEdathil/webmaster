import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webmaster/components/prompts.dart';
import 'package:webmaster/components/write_access.dart';
import 'package:webmaster/data/events.dart';
import 'package:webmaster/views/create.dart';

class HomeView extends StatelessWidget {
  void gotoCreate(BuildContext context) => Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => WriteView()));
  void unlockPrompt(BuildContext context) {
    showDialog(context: context, builder: (context) => UnlockPrompt());
  }

  void lockPrompt(BuildContext context) {
    showDialog(context: context, builder: (context) => LockPrompt());
  }

  @override
  Widget build(BuildContext context) {
    final events = Provider.of<EventModel>(context);
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          elevation: 0,
          actions: [
            WriteAccess(callback: () {
              if (events.writeAccess)
                lockPrompt(context);
              else
                unlockPrompt(context);
            })
          ],
        ),
        body: Center(
          child: Text(events.ready ? "Ready" : "Not"),
        ),
        floatingActionButton: events.writeAccess
            ? FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () => gotoCreate(context),
              )
            : null);
  }
}
