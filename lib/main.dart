import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webmaster/data/events.dart';
import 'package:webmaster/views/home.dart';

void main() {
  runApp(WebMasterApp());
}

class WebMasterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(),
      home: ChangeNotifierProvider(
          create: (context) => EventModel(), child: HomeView()),
    );
  }
}
