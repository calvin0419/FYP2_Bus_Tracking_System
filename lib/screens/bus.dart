import 'package:google_maps_flutter/google_maps_flutter.dart';

class Bus {
  final String busNumber;
  final String status;
  final LatLng location;

  Bus({required this.busNumber, required this.status, required this.location});

  factory Bus.fromJson(Map<String, dynamic> json) {
    return Bus(
      busNumber: json['busNumber'],
      status: json['status'],
      location: LatLng(
          json['location']['latitude'],
          json['location']['longitude']
      ),
    );
  }
}
