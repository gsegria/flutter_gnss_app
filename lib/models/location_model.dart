// lib/models/location_model.dart
// class LocationModel

class LocationModel {
  final double latitude;
  final double longitude;
  final double altitude;
  final double speed;
  final DateTime timestamp;

  LocationModel({
    required this.latitude,
    required this.longitude,
    required this.altitude,
    required this.speed,
    required this.timestamp,
  });

  // 轉成 Map，方便 CSV 或 JSON 匯出
  Map<String, dynamic> toMap() => {
        'latitude': latitude,
        'longitude': longitude,
        'altitude': altitude,
        'speed': speed,
        'timestamp': timestamp.toIso8601String(),
      };

  // 從 Map 建構 LocationModel
  factory LocationModel.fromMap(Map<String, dynamic> map) => LocationModel(
        latitude: map['latitude'] ?? 0,
        longitude: map['longitude'] ?? 0,
        altitude: map['altitude'] ?? 0,
        speed: map['speed'] ?? 0,
        timestamp: DateTime.parse(map['timestamp']),
      );
}