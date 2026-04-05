// lib/ui/log_screen.dart
// class LogScreen

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
  // 使用 singleton
  final GnssService _gnssService = GnssService.instance;
  final List<LocationModel> _logs = [];

  @override
  void initState() {
    super.initState();
    // 訂閱 GNSS 實時資料
    _gnssService.locationStream.listen((loc) {
      setState(() {
        _logs.add(loc);
      });
    });
  }

  // 匯出 CSV
  Future<void> _exportCsv() async {
    if (_logs.isEmpty) return;

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
          l.timestamp.toIso8601String(),
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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton.icon(
            icon: const Icon(Icons.download),
            label: const Text('Export CSV'),
            onPressed: _logs.isEmpty ? null : _exportCsv,
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _logs.length,
            itemBuilder: (context, index) {
              final loc = _logs[index];
              return ListTile(
                title: Text(
                    "Lat: ${loc.latitude.toStringAsFixed(6)}, Lng: ${loc.longitude.toStringAsFixed(6)}"),
                subtitle: Text(
                    "Alt: ${loc.altitude.toStringAsFixed(2)} m, Speed: ${loc.speed.toStringAsFixed(2)} m/s\nTime: ${loc.timestamp}"),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    // 不要 dispose singleton
    super.dispose();
  }
}