import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import '../services/gnss_service.dart';
import '../models/location_model.dart';

class LogScreen extends StatefulWidget {
  @override
  _LogScreenState createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {
  final GnssService _gnssService = GnssService();
  final List<LocationModel> _logs = [];

  @override
  void initState() {
    super.initState();
    _gnssService.locationStream.listen((loc) {
      setState(() {
        _logs.add(loc);
      });
    });
  }

  Future<void> _exportCsv() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/gnss_log.csv';
    List<List<dynamic>> rows = [
      ['Latitude', 'Longitude', 'Altitude', 'Speed', 'Timestamp']
    ];
    rows.addAll(_logs.map((l) => [
          l.latitude,
          l.longitude,
          l.altitude,
          l.speed,
          l.timestamp.toIso8601String()
        ]));
    String csvData = const ListToCsvConverter().convert(rows);
    final file = File(path);
    await file.writeAsString(csvData);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Log exported: $path')));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
            onPressed: _exportCsv, child: Text('Export CSV')),
        Expanded(
          child: ListView.builder(
            itemCount: _logs.length,
            itemBuilder: (context, index) {
              final loc = _logs[index];
              return ListTile(
                title: Text(
                    "Lat: ${loc.latitude}, Lng: ${loc.longitude}"),
                subtitle: Text(
                    "Alt: ${loc.altitude}m, Speed: ${loc.speed}m/s, Time: ${loc.timestamp}"),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _gnssService.dispose();
    super.dispose();
  }
}