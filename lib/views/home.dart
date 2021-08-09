import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webmaster/components/event_card.dart';
import 'package:webmaster/components/prompts.dart';
import 'package:webmaster/components/status_displays.dart';
import 'package:webmaster/data/events.dart';
import 'package:webmaster/views/write.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  void gotoCreate(BuildContext context) => Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => WriteView()));

  void unlockPrompt(BuildContext context) =>
      showDialog(context: context, builder: (context) => UnlockPrompt());

  void lockPrompt(BuildContext context) =>
      showDialog(context: context, builder: (context) => LockPrompt());

  void serverOnPrompt(BuildContext context) => showDialog(
      context: context, builder: (context) => ServerToggle(setTo: true));

  void serverOffPrompt(BuildContext context) => showDialog(
      context: context, builder: (context) => ServerToggle(setTo: false));

  @override
  Widget build(BuildContext context) {
    final events = Provider.of<EventModel>(context);
    return !events.ready
        ? Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: () async => setState(() =>
                Provider.of<EventModel>(context, listen: false).refresh()),
            child: Scaffold(
              backgroundColor: Theme.of(context).primaryColor,
              floatingActionButton: events.writeAccess
                  ? FloatingActionButton(
                      child: Icon(Icons.add),
                      onPressed: () => gotoCreate(context),
                    )
                  : null,
              body: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    flexibleSpace: Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: Image.asset('assets/logo.jpg'),
                    ),
                    expandedHeight: 300,
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
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => EventCard(index: index),
                      childCount: events.eventsCount,
                      addRepaintBoundaries: false,
                    ),
                  ),
                  SliverToBoxAdapter(
                      child: SizedBox(
                    height: 50,
                  ))
                ],
              ),
            ),
          );
  }
}
