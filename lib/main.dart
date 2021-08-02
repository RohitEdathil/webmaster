import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:webmaster/data/events.dart';
import 'package:webmaster/views/home.dart';

void main() {
  runApp(WebMasterApp());
}

class WebMasterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EventModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark().copyWith(
              primary: Colors.orange,
              secondary: Colors.orange,
            ),
            accentColor: Colors.orange,
            appBarTheme: AppBarTheme(
                systemOverlayStyle: SystemUiOverlayStyle(
              statusBarBrightness: Brightness.dark,
              statusBarColor: Colors.transparent,
            ))),
        home: HomeView(),
      ),
    );
  }
}
