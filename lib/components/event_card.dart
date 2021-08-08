import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webmaster/data/events.dart';

class EventCard extends StatelessWidget {
  final int index;
  const EventCard({required this.index});

  Chip stateChip(BuildContext context, int state) {
    switch (state) {
      case 0:
        return Chip(
          label: Text('Open'),
          backgroundColor: Colors.green,
        );
      case 1:
        return Chip(
          label: Text('Closed'),
          backgroundColor: Colors.blue,
        );
      default:
        return Chip(
          label: Text('Ended'),
          backgroundColor: Colors.red,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final content =
        Provider.of<EventModel>(context, listen: false).getThumb(index);
    return FutureBuilder<Map<String, dynamic>?>(
      future: content,
      builder: (context, snapshot) => !snapshot.hasData
          ? Container()
          : FractionallySizedBox(
              widthFactor:
                  MediaQuery.of(context).orientation == Orientation.portrait
                      ? 0.9
                      : 0.6,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                      color:
                          Theme.of(context).primaryColorDark.withOpacity(0.3),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(0),
                        minVerticalPadding: 0,
                        title: Image.network(snapshot.data!['thumb']),
                        subtitle: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              stateChip(context, snapshot.data!['status']),
                              SizedBox(width: 20),
                              Expanded(
                                child: Text(
                                  snapshot.data!['name'],
                                  textAlign: TextAlign.right,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                              )
                            ],
                          ),
                        ),
                        isThreeLine: true,
                      )),
                ),
              ),
            ),
    );
  }
}
