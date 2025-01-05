import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:bus_tracking_system/screens/gtfs-realtime.pb.dart';
import 'bus_info.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'dart:async';
import 'bus_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late GoogleMapController mapController;
  LatLng _currentPosition = LatLng(3.139, 101.6869);
  List<Map<String, dynamic>> nearbyBuses = [];
  Set<Marker> _markers = {};
  late Timer _timer;
  List<Map<String, dynamic>> filteredBuses = [];
  final PanelController _panelController = PanelController();

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    _getCurrentLocation().then((_) => _updateNearbyBuses());

    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      _updateNearbyBuses();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _requestLocationPermission() async {
    await Permission.location.request();
  }

  Future<void> _getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
      _addUserLocationMarker();
    });
    if (mapController != null) {
      mapController.animateCamera(CameraUpdate.newLatLng(_currentPosition));
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _addUserLocationMarker() {
    _markers.add(
      Marker(
        markerId: MarkerId('userLocation'),
        position: _currentPosition,
        infoWindow: InfoWindow(title: 'Your Location'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    );
  }

  Future<void> fetchRealtimeData() async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.data.gov.my/gtfs-realtime/vehicle-position/mybas-johor/'));
      if (response.statusCode == 200) {
        final feed = FeedMessage.fromBuffer(response.bodyBytes);

        final buses = feed.entity.where((entity) {
          if (entity.hasVehicle()) {
            final vehicle = entity.vehicle;
            final busLat = vehicle.position.latitude;
            final busLng = vehicle.position.longitude;

            final distance =
                calculateDistance(_currentPosition, LatLng(busLat, busLng));
            return distance <= 5000.0;
          }
          return false;
        }).map((entity) {
          final vehicle = entity.vehicle;
          final currentStopSequence = entity.vehicle.hasCurrentStopSequence()
              ? entity.vehicle.currentStopSequence
              : null;

          List<String> nextStops =
              _getNextStops(vehicle.trip.routeId, currentStopSequence);

          String actualArrivalTime = _calculateActualArrivalTime(
              vehicle.trip.tripId, currentStopSequence);

          return {
            'routeId': vehicle.trip.routeId,
            'arrivalTime': vehicle.timestamp.toInt(),
            'actualArrivalTime': actualArrivalTime is String
                ? int.tryParse(actualArrivalTime)
                : actualArrivalTime,
            'position':
                LatLng(vehicle.position.latitude, vehicle.position.longitude),
            'direction': vehicle.trip.directionId == 0 ? 'Inbound' : 'Outbound',
            'nextStops': nextStops,
            'currentStopSequence': currentStopSequence,
            'licensePlate': vehicle.vehicle.id,
          };
        }).toList();

        setState(() {
          nearbyBuses = buses;
          filteredBuses = nearbyBuses;
          _updateMarkers();
        });
      }
    } catch (e) {
      print('Error fetching or processing GTFS data: $e');
    }
  }

  void _updateMarkers() {
    _markers.clear();
    _addUserLocationMarker();
    for (var bus in filteredBuses) {
      _markers.add(
        Marker(
          markerId: MarkerId(bus['routeId']),
          position: bus['position'],
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
          onTap: () => _onBusMarkerTapped(bus),
        ),
      );
    }
  }

  void _onBusMarkerTapped(Map<String, dynamic> bus) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BusInfoScreen(
          routeId: bus['routeId'],
          busId: bus['licensePlate'],
          licensePlate: bus['licensePlate'],
        ),
      ),
    );
  }

  String _calculateActualArrivalTime(String? tripId, int? currentStopSequence) {
    if (tripId == null || currentStopSequence == null) {
      return 'N/A';
    }
    String stopTimeKey = '$tripId:$currentStopSequence';
    return BusService.stopTimes[stopTimeKey] ?? 'N/A';
  }

  List<String> _getNextStops(String routeId, int? currentStopSequence) {
    List<String> stops = [];
    if (currentStopSequence != null) {
      int index = currentStopSequence;
      for (int i = index; i < index + 3 && i < stops.length; i++) {
        stops.add(stops[i]);
      }
    }
    return stops;
  }

  double calculateDistance(LatLng point1, LatLng point2) {
    return Geolocator.distanceBetween(
      point1.latitude,
      point1.longitude,
      point2.latitude,
      point2.longitude,
    );
  }

  String _formatTime(int timestamp) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _updateNearbyBuses() {
    fetchRealtimeData();
  }

  Widget _buildBusListItem(Map<String, dynamic> bus) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        onTap: () => _onBusMarkerTapped(bus),
        leading: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            bus['routeId'],
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text('Next Arrival: ${_formatTime(bus['arrivalTime'])}'),
        subtitle: Text(bus['direction']),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingUpPanel(
        controller: _panelController,
        minHeight: MediaQuery.of(context).size.height * 0.2,
        maxHeight: MediaQuery.of(context).size.height * 0.7,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        body: Stack(
          children: [
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _currentPosition,
                zoom: 14,
              ),
              markers: _markers,
              myLocationEnabled: false,
              myLocationButtonEnabled: false,
            ),
            Positioned(
              top: 40,
              left: 16,
              right: 16,
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search and Track Bus',
                    prefixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.22,
              right: 16,
              child: FloatingActionButton(
                onPressed: _getCurrentLocation,
                child: Icon(Icons.my_location),
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue,
              ),
            ),
          ],
        ),
        panel: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Nearby Buses',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${filteredBuses.length} buses found',
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 8),
                itemCount: filteredBuses.length,
                itemBuilder: (context, index) =>
                    _buildBusListItem(filteredBuses[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

