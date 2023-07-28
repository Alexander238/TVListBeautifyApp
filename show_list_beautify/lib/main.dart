import 'package:flutter/material.dart';
import 'package:show_list_beautify/screens/home_page.dart';
import 'package:show_list_beautify/screens/list_input.dart';

void main() {
  runApp(const MyApp());
}

// define the navigator key
final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
     return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: const HomePage(),
      // define the routes
      routes: {
        '/home_page': (context) => const HomePage(),
      },
    );
  }
}

