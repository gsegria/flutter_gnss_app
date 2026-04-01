import 'package:flutter/material.dart';
import 'ui/map_screen.dart';
import 'ui/track_screen.dart';
import 'ui/log_screen.dart';

void main() {
  runApp(GnssApp());
}

class GnssApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter GNSS App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> pages = [
    {'title': 'Map', 'widget': MapScreen()},
    {'title': 'Track', 'widget': TrackScreen()},
    {'title': 'Log', 'widget': LogScreen()},
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: pages.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('GNSS App'),
          bottom: TabBar(
            tabs: pages.map((p) => Tab(text: p['title'])).toList(),
          ),
        ),
        body: TabBarView(
          children: pages.map((p) => p['widget'] as Widget).toList(),
        ),
      ),
    );
  }
}