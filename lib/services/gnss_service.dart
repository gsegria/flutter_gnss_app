// lib/services/gnss_service.dart
// class GnssService

import 'dart:async';
import 'package:geolocator/geolocator.dart';
import '../models/location_model.dart';

class GnssService {
  // Singleton 建構子
  GnssService._privateConstructor() {
    _init();
  }

  // 全域單例
  static final GnssService instance = GnssService._privateConstructor();

  // 廣播 Stream，供多個頁面訂閱
  final StreamController<LocationModel> _locationController =
      StreamController<LocationModel>.broadcast();

  Stream<LocationModel> get locationStream => _locationController.stream;

  // 初始化 GNSS / Geolocator
  void _init() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) return;

    // 訂閱定位流
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 1, // 每移動 1 公尺更新一次
      ),
    ).listen((Position pos) {
      final location = LocationModel(
        latitude: pos.latitude,
        longitude: pos.longitude,
        altitude: pos.altitude,
        speed: pos.speed,
        timestamp: DateTime.now(),
      );
      _locationController.add(location);
    });
  }

  // 關閉 Stream
  void dispose() {
    _locationController.close();
  }
}