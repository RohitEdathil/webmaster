import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  final int index;
  const EventCard({required this.index});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: MediaQuery.of(context).orientation == Orientation.portrait
          ? 0.9
          : 0.6,
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Container(
            color: Theme.of(context).primaryColorDark.withOpacity(0.3),
            child: ListTile(
              contentPadding: EdgeInsets.all(0),
              minVerticalPadding: 0,
              title: Image.network(
                  "https://images.unsplash.com/photo-1549880433-e556bbd93270?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1050&q=80"),
              subtitle: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Chip(
                      label: Text('Closed'),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Text(
                        'Introduction to Photoshop',
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
            ),
          ),
        ),
      ),
    );
  }
}
