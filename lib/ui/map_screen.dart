// lib/ui/map_screen.dart
// class MapScreen

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../services/gnss_service.dart';
import '../models/location_model.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;

  // 初始位置預設 0,0，會在第一筆 GNSS 更新後移動
  LatLng _currentPosition = const LatLng(0, 0);

  // 航跡線
  final Set<Polyline> _polylines = {};
  final List<LatLng> _track = [];

  @override
  void initState() {
    super.initState();

    // 訂閱 GnssService 的實時位置流
    GnssService.instance.locationStream.listen((LocationModel loc) {
      setState(() {
        _currentPosition = LatLng(loc.latitude, loc.longitude);
        _track.add(_currentPosition);

        // 更新航跡線
        _polylines.clear();
        _polylines.add(Polyline(
          polylineId: const PolylineId('track'),
          points: _track,
          color: Colors.blue,
          width: 4,
        ));
      });

      // 地圖自動移動到最新位置
      _mapController.animateCamera(CameraUpdate.newLatLng(_currentPosition));
    });
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: _currentPosition,
        zoom: 17,
      ),
      onMapCreated: (controller) => _mapController = controller,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      polylines: _polylines,
    );
  }
}