import 'package:flutter/material.dart';
import '../services/gnss_service.dart';
import '../models/location_model.dart';

// lib/ui/track_screen.dart
// class TrackScreen

class TrackScreen extends StatefulWidget {
  @override
  _TrackScreenState createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen> {
  // 使用 singleton
  final GnssService _gnssService = GnssService.instance;
  final List<LocationModel> _track = [];

  @override
  void initState() {
    super.initState();
    // 訂閱 GNSS 實時資料
    _gnssService.locationStream.listen((loc) {
      setState(() {
        _track.add(loc);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _track.length,
      itemBuilder: (context, index) {
        final loc = _track[index];
        return ListTile(
          title: Text(
              "Lat: ${loc.latitude.toStringAsFixed(6)}, Lng: ${loc.longitude.toStringAsFixed(6)}"),
          subtitle: Text(
              "Alt: ${loc.altitude.toStringAsFixed(2)} m, Speed: ${loc.speed.toStringAsFixed(2)} m/s\nTime: ${loc.timestamp}"),
        );
      },
    );
  }

  @override
  void dispose() {
    // 不要 dispose singleton，避免其他頁面失效
    super.dispose();
  }
}