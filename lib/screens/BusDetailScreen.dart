import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:bus_tracking_system/screens/gtfs-realtime.pb.dart';
import 'package:csv/csv.dart';
import 'dart:math';

class BusDetailScreen extends StatefulWidget {
  final Map<String, dynamic> busDetails;
  final String routeId;
  final String busId;
  final String currentStopSequence;

  const BusDetailScreen({
    super.key,
    required this.busDetails,
    required this.routeId,
    required this.busId,
    required this.currentStopSequence,
  });

  @override
  _BusDetailScreenState createState() => _BusDetailScreenState();
}

class _BusDetailScreenState extends State<BusDetailScreen> {
  late Timer _timer;
  late Map<String, dynamic> busDetails;
  late Set<Marker> _busStopMarkers;
  late Set<Polyline> _routePolylines;
  late List<Map<String, dynamic>> _staticBusStops;
  late String busDirection;

  @override
  void initState() {
    super.initState();
    busDetails = widget.busDetails;
    _staticBusStops = [];
    _busStopMarkers = _buildBusStopMarkers(busDetails);
    _routePolylines = _buildRoutePolyline(busDetails['routeId']);

    busDirection = 'Loading...';

    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      _refreshBusLocation();
    });

    _loadStaticGTFSData();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _loadStaticGTFSData() async {
    try {
      final response = await http
          .get(Uri.parse('https://api.data.gov.my/gtfs-static/mybas-johor'));

      if (response.statusCode == 200) {
        print('Raw CSV Data: ${response.body}');

        String csvData = response.body;
        List<List<dynamic>> rows = CsvToListConverter().convert(csvData);

        print('Parsed Rows: $rows');

        if (rows.isNotEmpty && rows[0].length >= 4) {
          List<Map<String, dynamic>> staticBusStops = rows.map((row) {
            return {
              'stop_id': row[0],
              'stop_name': row[1],
              'latitude': row[2],
              'longitude': row[3],
            };
          }).toList();

          setState(() {
            _staticBusStops = staticBusStops;

            if (_staticBusStops.isNotEmpty) {
              String startStop = _staticBusStops.first['stop_name'];
              String endStop = _staticBusStops.last['stop_name'];
              busDirection = 'From $startStop to $endStop';
            } else {
              busDirection = 'No bus stops available';
            }
          });
        } else {
          throw Exception('CSV rows are empty or have an invalid structure');
        }
      } else {
        throw Exception('Failed to load static GTFS data');
      }
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        _staticBusStops = [];
        busDirection = 'Error loading bus data';
      });
    }
  }

  Future<void> _fetchRealTimeGTFSData() async {
    final String apiUrl =
        'https://api.data.gov.my/gtfs-realtime/vehicle-position/mybas-johor';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final feed = FeedMessage.fromBuffer(response.bodyBytes);

        if (feed.entity.isNotEmpty) {
          final vehicleEntity = feed.entity[0];

          if (vehicleEntity.vehicle != null &&
              vehicleEntity.vehicle!.position != null) {
            final vehiclePosition = vehicleEntity.vehicle!.position;

            setState(() {
              busDetails['position'] =
                  LatLng(vehiclePosition.latitude, vehiclePosition.longitude);
              _busStopMarkers =
                  _buildBusStopMarkers(busDetails);
            });
          } else {
            print('No vehicle position data available');
          }
        } else {
          print('No vehicle entities found');
        }
      } else {
        throw Exception('Failed to fetch real-time GTFS data');
      }
    } catch (e) {
      print('Error fetching real-time data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Failed to fetch real-time data. Please try again.')),
      );
    }
  }

  void _refreshBusLocation() {
    _fetchRealTimeGTFSData();
  }

  Set<Marker> _buildBusStopMarkers(Map<String, dynamic> busDetails) {
    Set<Marker> markers = {};

    for (var stop in _staticBusStops) {
      LatLng stopPosition = LatLng(stop['latitude'], stop['longitude']);
      markers.add(
        Marker(
          markerId: MarkerId('stop_${stop['stop_id']}'),
          position: stopPosition,
          infoWindow: InfoWindow(
            title: stop['stop_name'],
            snippet: 'Stop ID: ${stop['stop_id']}',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
    }

    markers.add(
      Marker(
        markerId: MarkerId('bus_${widget.busId}'),
        position: busDetails['position'],
        infoWindow: InfoWindow(
          title: 'Bus ${widget.routeId}',
          snippet: 'Current Location',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      ),
    );

    return markers;
  }

  Set<Polyline> _buildRoutePolyline(String routeId) {
    List<LatLng> routeCoordinates = [
      LatLng(3.139, 101.6869),
      LatLng(3.149, 101.6969),
      LatLng(3.159, 101.7069),
    ];

    return {
      Polyline(
        polylineId: PolylineId(routeId),
        points: routeCoordinates,
        color: Colors.blue,
        width: 5,
      ),
    };
  }

  double calculateDistance(LatLng position1, LatLng position2) {
    const R = 6371;
    double dLat = (position2.latitude - position1.latitude) * (pi / 180);
    double dLng = (position2.longitude - position1.longitude) * (pi / 180);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(position1.latitude * (pi / 180)) *
            cos(position2.latitude * (pi / 180)) *
            sin(dLng / 2) *
            sin(dLng / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    double distance = R * c;
    return distance * 1000;
  }

  List<String> _getNextStops(String routeId, int? currentStopSequence) {
    List<String> nextStops = [];

    if (routeId != null && currentStopSequence != null) {
      nextStops = [
        'Stop 1',
        'Stop 2',
        'Stop 3'
      ];
    }

    return nextStops;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bus Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Route ID: ${busDetails['routeId']}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Direction: $busDirection',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Next Stops:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ...?busDetails['nextStops']?.map<Widget>((stop) {
                  return Text(
                    stop,
                    style: TextStyle(fontSize: 16),
                  );
                }).toList() ??
                [],
            SizedBox(height: 10),
            Text(
              'License Plate: ${busDetails['licensePlate']}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Expanded(
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: busDetails['position'],
                  zoom: 14,
                ),
                markers: _busStopMarkers,
                polylines: _routePolylines,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
