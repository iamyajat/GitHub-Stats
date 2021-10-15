import 'package:flutter/material.dart';
import 'package:githubstats/screens/home.dart';
import 'package:githubstats/screens/stats.dart';
import 'package:githubstats/utils/strings.dart' as strings;

void main() => runApp(const GitHubStatsApp());

class GitHubStatsApp extends StatelessWidget {
  const GitHubStatsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: strings.appTitle,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromRGBO(30, 30, 30, 100),
        hintColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
        textTheme: const TextTheme(
          bodyText1: TextStyle(),
          bodyText2: TextStyle(),
        ).apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
      ),
      home: const HomePage(),
    );
  }
}
