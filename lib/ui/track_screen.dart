import 'package:flutter/material.dart';
import '../services/gnss_service.dart';
import '../models/location_model.dart';

class TrackScreen extends StatefulWidget {
  @override
  _TrackScreenState createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen> {
  final GnssService _gnssService = GnssService();
  final List<LocationModel> _track = [];

  @override
  void initState() {
    super.initState();
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
              "Alt: ${loc.altitude}m, Speed: ${loc.speed}m/s, Time: ${loc.timestamp}"),
        );
      },
    );
  }

  @override
  void dispose() {
    _gnssService.dispose();
    super.dispose();
  }
}