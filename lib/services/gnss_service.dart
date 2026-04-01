import 'dart:async';
import 'package:geolocator/geolocator.dart';
import '../models/location_model.dart';

class GnssService {
  final StreamController<LocationModel> _locationController =
      StreamController<LocationModel>.broadcast();

  Stream<LocationModel> get locationStream => _locationController.stream;

  GnssService() {
    _init();
  }

  void _init() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) return;

    Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 1,
      ),
    ).listen((Position pos) {
      _locationController.add(LocationModel(
        latitude: pos.latitude,
        longitude: pos.longitude,
        altitude: pos.altitude,
        speed: pos.speed,
        timestamp: DateTime.now(),
      ));
    });
  }

  void dispose() {
    _locationController.close();
  }
}