import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webmaster/components/prompts.dart';
import 'package:webmaster/components/status_displays.dart';
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

  void serverOnPrompt(BuildContext context) {
    showDialog(
        context: context, builder: (context) => ServerToggle(setTo: true));
  }

  void serverOffPrompt(BuildContext context) {
    showDialog(
        context: context, builder: (context) => ServerToggle(setTo: false));
  }

  @override
  Widget build(BuildContext context) {
    final events = Provider.of<EventModel>(context);
    return !events.ready
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            backgroundColor: Theme.of(context).primaryColor,
            appBar: AppBar(
              elevation: 0,
              actions: [
                events.writeAccess
                    ? ServerStatus(
                        callback: () => events.serverStatus
                            ? serverOffPrompt(context)
                            : serverOnPrompt(context),
                      )
                    : Container(),
                WriteAccess(
                  callback: () => events.writeAccess
                      ? lockPrompt(context)
                      : unlockPrompt(context),
                ),
              ],
            ),
            floatingActionButton: events.writeAccess
                ? FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => gotoCreate(context),
                  )
                : null,
            body: Center(
              child: Text('Hello'),
            ),
          );
  }
}
