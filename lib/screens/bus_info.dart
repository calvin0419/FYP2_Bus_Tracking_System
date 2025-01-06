import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:bus_tracking_system/screens/gtfs-realtime.pb.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:developer' as developer;
import 'dart:math';
import 'dart:convert';
import 'dart:io';

class BusInfoScreen extends StatefulWidget {
  final String routeId;
  final String busId;
  final String licensePlate;

  const BusInfoScreen({
    Key? key,
    required this.routeId,
    required this.busId,
    required this.licensePlate,
  }) : super(key: key);

  @override
  _BusInfoScreenState createState() => _BusInfoScreenState();
}

class _BusInfoScreenState extends State<BusInfoScreen>
    with SingleTickerProviderStateMixin {
  bool isLoading = true;
  String selectedRouteId = '';
  String selectedBusId = '';
  String licensePlate = '';
  String currentStop = 'Loading...';
  String nextStop = 'Loading...';
  String lastPassedStop = '';
  double busLatitude = 0.0;
  double busLongitude = 0.0;
  int currentStopSequence = 0;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  GoogleMapController? _mapController;
  late Map<String, dynamic> gtfsData;
  List<String> stops = [];
  List<String> remainingStops = [];
  List<LatLng> completedRouteSegment = [];
  List<LatLng> currentRouteSegment = [];
  String direction = '';
  Timer? _refreshTimer;
  bool isMapInitialized = false;
  String busStatus = '';
  String specificTripId = '';
  List<Map<String, dynamic>> stopCoordinates = [];
  String previousStop = '';
  Map<String, bool> passedStops = {};
  double _threshold = 100.0;
  String previousTripId = '';
  bool isShortRoute = false;
  int minimumStopThreshold = 2;
  late TabController _tabController;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  bool _isFollowingBus = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    selectedRouteId = widget.routeId;
    selectedBusId = widget.busId;
    licensePlate = widget.licensePlate;
    loadGTFSData();
    _startRefreshTimer();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _mapController?.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> loadGTFSData() async {
    try {
      gtfsData = await GTFSService().fetchGTFSStaticData();
      developer.log('GTFS Data loaded successfully');
      await fetchBusInfo();
    } catch (e) {
      developer.log('Error loading GTFS data: $e');
      _showError('Error loading GTFS data: $e');
    }
  }

  Future<void> fetchBusInfo() async {
    final String apiUrl =
        'https://api.data.gov.my/gtfs-realtime/vehicle-position/mybas-johor/';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final feed = FeedMessage.fromBuffer(response.bodyBytes);
        bool foundBus = false;

        for (var entity in feed.entity) {
          if (entity.vehicle != null &&
              entity.vehicle!.vehicle.id == selectedBusId &&
              entity.vehicle!.trip.routeId == selectedRouteId) {
            foundBus = true;
            var vehicle = entity.vehicle!;
            var position = vehicle.position;

            specificTripId = vehicle.trip.tripId;

            if (specificTripId.isEmpty) {
              List<List<dynamic>> trips = gtfsData['trips'];
              var routeTrips = trips
                  .where((trip) => trip[0].toString() == selectedRouteId)
                  .toList();

              if (routeTrips.isNotEmpty) {
                specificTripId = routeTrips.first[2].toString();
                isShortRoute = true;
              }
            }

            setState(() {
              busLatitude = position.latitude;
              busLongitude = position.longitude;
              licensePlate = vehicle.vehicle.licensePlate.isNotEmpty
                  ? vehicle.vehicle.licensePlate
                  : selectedBusId;
              currentStopSequence = vehicle.currentStopSequence;
              busStatus = vehicle.currentStatus.toString();
            });

            await _updateStopsForSpecificTrip();

            if (stops.length < minimumStopThreshold) {
              _handleShortRoute(position);
            } else {
              _updateMapElements(position);
            }

            setState(() {
              isLoading = false;
            });

            _centerMapOnBus(position);
            break;
          }
        }

        if (!foundBus) {
          developer.log('Bus not found in feed');
          setState(() {
            isLoading = false;
          });
          _showError('Bus not found');
        }
      } else if (response.statusCode == 429) {
        throw Exception('Rate limit exceeded. Please try again later.');
      } else if (response.statusCode >= 500) {
        throw Exception('Server error. Please try again later.');
      } else {
        throw Exception('Failed to load bus information');
      }
    } catch (error) {
      if (error is SocketException) {
        throw Exception(
            'Network connection error. Please check your internet connection.');
      }
      developer.log('Error fetching bus info: $error');
      rethrow;
    }
  }

  Future<void> fetchBusInfoWithRetry() async {
    int maxRetries = 3;
    int currentTry = 0;

    while (currentTry < maxRetries) {
      try {
        await fetchBusInfo();
        break;
      } catch (e) {
        currentTry++;
        if (currentTry == maxRetries) {
          throw e;
        }
        await Future.delayed(Duration(seconds: 2));
      }
    }
  }

  Future<void> _updateStopsForSpecificTrip() async {
    try {
      List<List<dynamic>> stopTimes = gtfsData['stop_times'];
      List<List<dynamic>> stopsData = gtfsData['stops'];

      var stopTimesForTrip = stopTimes
          .where((stopTime) => stopTime[0].toString() == specificTripId)
          .toList()
        ..sort((a, b) =>
            int.parse(a[4].toString()).compareTo(int.parse(b[4].toString())));

      if (stopTimesForTrip.isEmpty) {
        stops = _getStopsForRoute(selectedRouteId);
      } else {
        stops = [];
        stopCoordinates = [];

        for (var stopTime in stopTimesForTrip) {
          String stopId = stopTime[3].toString();
          var stop = stopsData.firstWhere(
            (stop) => stop[0].toString() == stopId,
            orElse: () => [],
          );

          if (stop.isNotEmpty) {
            String stopName = stop[2].toString();
            stops.add(stopName);
            stopCoordinates.add({
              'name': stopName,
              'latitude': double.parse(stop[4].toString()),
              'longitude': double.parse(stop[5].toString()),
              'sequence': int.parse(stopTime[4].toString()),
            });
          }
        }
      }

      setState(() {
        if (stops.isNotEmpty) {
          int nextStopIndex = 0;
          for (int i = 0; i < stops.length; i++) {
            if (!passedStops.containsKey(stops[i])) {
              nextStopIndex = i;
              break;
            }
          }

          if (nextStopIndex > 0) {
            lastPassedStop = stops[nextStopIndex - 1];
          }
          currentStop = stops[nextStopIndex];
          nextStop = nextStopIndex + 1 < stops.length
              ? stops[nextStopIndex + 1]
              : 'Final Stop';

          int closestStopIndex = -1;

          double minDistance = double.infinity;

          for (int i = 0; i < stopCoordinates.length; i++) {
            var stop = stopCoordinates[i];
            double distance = _calculateDistance(
                busLatitude, busLongitude, stop['latitude'], stop['longitude']);

            if (distance < minDistance) {
              minDistance = distance;
              closestStopIndex = i;
            }

            if (distance < _threshold &&
                !passedStops.containsKey(stop['name'])) {
              passedStops[stop['name']] = true;
              lastPassedStop = stop['name'];
            }
          }

          remainingStops = stopCoordinates
              .sublist(closestStopIndex)
              .map((stop) => stop['name'] as String)
              .toList();

          if (stops.length >= 2) {
            direction = '${stops.first} → ${stops.last}';
          }

          List<LatLng> completedPoints = [];
          for (int i = 0;
              i <= nextStopIndex && i < stopCoordinates.length;
              i++) {
            completedPoints.add(LatLng(
              stopCoordinates[i]['latitude'],
              stopCoordinates[i]['longitude'],
            ));
          }
          completedRouteSegment = completedPoints;
        }
      });
    } catch (e) {
      developer.log('Error updating stops: $e');
      _showError('Error updating stops: $e');
    }
  }

  Future<List<LatLng>> _getRouteCoordinates(
      LatLng origin, LatLng destination) async {
    final String apiKey = 'AIzaSyDM_H7xFxkgDsxbDOsqdeBBuzEyFkfpa4M';
    final String baseUrl =
        'https://maps.googleapis.com/maps/api/directions/json';

    try {
      final response = await http.get(
        Uri.parse('$baseUrl?origin=${origin.latitude},${origin.longitude}'
            '&destination=${destination.latitude},${destination.longitude}'
            '&mode=driving'
            '&key=$apiKey'),
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        if (decoded['status'] == 'OK' && decoded['routes'].isNotEmpty) {
          final points = decoded['routes'][0]['overview_polyline']['points'];
          return _decodePolyline(points);
        }
      }

      return [origin, destination];
    } catch (e) {
      developer.log('Error fetching route: $e');
      return [origin, destination];
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, lat = 0, lng = 0;
    final len = encoded.length;

    while (index < len) {
      int shift = 0;
      int result = 0;

      do {
        result |= (encoded.codeUnitAt(index++) & 0x1F) << shift;
        shift += 5;
      } while (index < len && (encoded.codeUnitAt(index - 1) >= 0x20));

      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;

      if (index < len) {
        do {
          result |= (encoded.codeUnitAt(index++) & 0x1F) << shift;
          shift += 5;
        } while (index < len && (encoded.codeUnitAt(index - 1) >= 0x20));

        int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
        lng += dlng;
      }

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return points;
  }

  List<String> _getStopsForRoute(String routeId) {
    try {
      List<List<dynamic>> trips = gtfsData['trips'];
      List<List<dynamic>> stopTimes = gtfsData['stop_times'];
      List<List<dynamic>> stopsData = gtfsData['stops'];

      var tripsForRoute =
          trips.where((trip) => trip[0].toString() == routeId).toList();
      if (tripsForRoute.isEmpty) return [];

      String tripId = tripsForRoute.first[2].toString();
      var stopTimesForTrip = stopTimes
          .where((stopTime) => stopTime[0].toString() == tripId)
          .toList()
        ..sort((a, b) =>
            int.parse(a[4].toString()).compareTo(int.parse(b[4].toString())));

      stopCoordinates = [];
      List<String> stopNames = [];

      for (var stopTime in stopTimesForTrip) {
        String stopId = stopTime[3].toString();
        var stop = stopsData.firstWhere(
          (stop) => stop[0].toString() == stopId,
          orElse: () => [],
        );

        if (stop.isNotEmpty) {
          String stopName = stop[2].toString();
          stopNames.add(stopName);
          stopCoordinates.add({
            'name': stopName,
            'latitude': double.parse(stop[4].toString()),
            'longitude': double.parse(stop[5].toString()),
            'sequence': int.parse(stopTime[4].toString()),
          });
        }
      }

      return stopNames;
    } catch (e) {
      developer.log('Error getting stops for route: $e');
      return [];
    }
  }

  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371000;
    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  double _toRadians(double degree) {
    return degree * pi / 180;
  }

  void _updateMapElements(Position position) async {
    LatLng busPosition = LatLng(position.latitude, position.longitude);

    double minDistance = double.infinity;
    int closestStopIndex = -1;

    for (int i = 0; i < stopCoordinates.length; i++) {
      var stop = stopCoordinates[i];
      double distance = _calculateDistance(position.latitude,
          position.longitude, stop['latitude'], stop['longitude']);

      if (distance < minDistance) {
        minDistance = distance;
        closestStopIndex = i;
      }

      if (distance < _threshold && !passedStops.containsKey(stop['name'])) {
        passedStops[stop['name']] = true;
        lastPassedStop = stop['name'];
      }
    }

    setState(() {
      currentStop = stopCoordinates[closestStopIndex]['name'];
      nextStop = (closestStopIndex + 1 < stopCoordinates.length)
          ? stopCoordinates[closestStopIndex + 1]['name']
          : 'Final Stop';

      remainingStops = stopCoordinates
          .sublist(closestStopIndex)
          .map((stop) => stop['name'] as String)
          .toList();
    });

    List<LatLng> currentSegmentPoints = [];
    List<LatLng> remainingRoutePoints = [];
    if (remainingStops.isNotEmpty) {
      var nextStopData = _getStopData(remainingStops[0]);
      if (nextStopData.isNotEmpty) {
        LatLng nextStopPosition = LatLng(
          nextStopData['latitude'],
          nextStopData['longitude'],
        );
        currentSegmentPoints =
            await _getRouteCoordinates(busPosition, nextStopPosition);
      }
    }

    for (int i = 0; i < remainingStops.length - 1; i++) {
      var currentStopData = _getStopData(remainingStops[i]);
      var nextStopData = _getStopData(remainingStops[i + 1]);

      if (currentStopData.isNotEmpty && nextStopData.isNotEmpty) {
        LatLng origin = LatLng(
          currentStopData['latitude'],
          currentStopData['longitude'],
        );
        LatLng destination = LatLng(
          nextStopData['latitude'],
          nextStopData['longitude'],
        );

        var segmentPoints = await _getRouteCoordinates(origin, destination);
        remainingRoutePoints.addAll(segmentPoints);
      }
    }

    if (currentStop != previousStop) {
      currentRouteSegment.clear();
      previousStop = currentStop;
    }
    currentRouteSegment.add(busPosition);

    setState(() {
      polylines = {
        if (currentSegmentPoints.isNotEmpty)
          Polyline(
            polylineId: const PolylineId('current_segment'),
            points: currentSegmentPoints,
            color: Colors.orange,
            width: 5,
          ),
        if (remainingRoutePoints.isNotEmpty)
          Polyline(
            polylineId: const PolylineId('planned_route'),
            points: remainingRoutePoints,
            color: Colors.blue,
            width: 3,
          ),
      };

      markers = {
        Marker(
          markerId: MarkerId('bus_$selectedBusId'),
          position: busPosition,
          infoWindow: InfoWindow(
            title: 'Bus $licensePlate',
            snippet: 'Status: $busStatus\nLast Stop: $lastPassedStop',
          ),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        ),
        ...remainingStops.map((stopName) {
          var stopData = _getStopData(stopName);
          bool isCurrentStop = stopName == currentStop;

          return Marker(
            markerId: MarkerId('stop_$stopName'),
            position: LatLng(
              stopData['latitude'],
              stopData['longitude'],
            ),
            infoWindow: InfoWindow(
              title: stopName,
              snippet: isCurrentStop ? 'Current Stop' : 'Upcoming Stop',
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              isCurrentStop
                  ? BitmapDescriptor.hueGreen
                  : BitmapDescriptor.hueBlue,
            ),
          );
        }),
      };
    });
  }

  void _handleShortRoute(Position position) {
    LatLng busPosition = LatLng(position.latitude, position.longitude);

    List<String> routeStops = _getStopsForRoute(selectedRouteId);

    developer.log('Route stops found: ${routeStops.length}');
    developer.log('Stop coordinates available: ${stopCoordinates.length}');

    if (routeStops.isNotEmpty && stopCoordinates.isNotEmpty) {
      setState(() {
        isShortRoute = true;
        stops = routeStops;

        double minDistance = double.infinity;
        String closestStop = '';
        String nextStopName = '';

        for (var stopData in stopCoordinates) {
          double distance = _calculateDistance(position.latitude,
              position.longitude, stopData['latitude'], stopData['longitude']);

          if (distance < minDistance) {
            minDistance = distance;
            closestStop = stopData['name'];
            int index = stops.indexOf(closestStop);
            if (index < stops.length - 1) {
              nextStopName = stops[index + 1];
            }
          }
        }

        currentStop = closestStop.isNotEmpty ? closestStop : 'On Route';
        nextStop = nextStopName.isNotEmpty ? nextStopName : 'Route End';

        Set<Marker> newMarkers = {};

        newMarkers.add(Marker(
          markerId: MarkerId('bus_$selectedBusId'),
          position: busPosition,
          infoWindow: InfoWindow(
            title: 'Bus $licensePlate',
            snippet: 'Status: $busStatus',
          ),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        ));

        for (var stopData in stopCoordinates) {
          bool isCurrentStop = stopData['name'] == currentStop;
          newMarkers.add(Marker(
            markerId: MarkerId('stop_${stopData['name']}'),
            position: LatLng(
              stopData['latitude'],
              stopData['longitude'],
            ),
            infoWindow: InfoWindow(
              title: stopData['name'],
              snippet: isCurrentStop ? 'Current Stop' : 'Bus Stop',
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              isCurrentStop
                  ? BitmapDescriptor.hueGreen
                  : BitmapDescriptor.hueBlue,
            ),
          ));
        }

        markers = newMarkers;

        List<LatLng> routePoints = [];
        for (var stop in stopCoordinates) {
          routePoints.add(LatLng(stop['latitude'], stop['longitude']));
        }

        if (routePoints.length >= 2) {
          polylines = {
            Polyline(
              polylineId: const PolylineId('route'),
              points: routePoints,
              color: Colors.blue,
              width: 3,
            ),
          };
        } else {
          polylines = {};
        }
      });
    } else {
      developer.log('No stops or coordinates found for route $selectedRouteId');

      setState(() {
        isShortRoute = true;
        currentStop = 'On Route';
        nextStop = 'Route End';

        markers = {
          Marker(
            markerId: MarkerId('bus_$selectedBusId'),
            position: busPosition,
            infoWindow: InfoWindow(
              title: 'Bus $licensePlate',
              snippet: 'Status: $busStatus',
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueOrange),
          ),
        };

        polylines = {};
      });
    }
  }

  void _centerMapOnBus(Position position) {
    if (isMapInitialized && _mapController != null && _isFollowingBus) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(position.latitude, position.longitude),
          15,
        ),
      );
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 5),
        action: SnackBarAction(
          label: 'Retry',
          onPressed: () {
            fetchBusInfo();
          },
        ),
      ),
    );
  }

  Map<String, dynamic> _getStopData(String stopName) {
    return stopCoordinates.firstWhere(
      (stop) => stop['name'] == stopName,
      orElse: () => {},
    );
  }

  void _startRefreshTimer() {
    _refreshTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      loadGTFSData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _mapController?.dispose();
        return true;
      },
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 200.0,
                floating: false,
                pinned: true,
                backgroundColor: Theme.of(context).primaryColor,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                      'Bus ${licensePlate.isNotEmpty ? licensePlate : "Loading..."}'),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Theme.of(context).primaryColor,
                          Theme.of(context).primaryColor.withOpacity(0.7),
                        ],
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        Icon(
                          Icons.directions_bus,
                          size: 48,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Route $selectedRouteId',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () {
                      _refreshIndicatorKey.currentState?.show();
                      fetchBusInfo();
                    },
                  ),
                ],
              ),
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    controller: _tabController,
                    tabs: const [
                      Tab(text: 'LIVE TRACKING'),
                      Tab(text: 'STOPS'),
                    ],
                    labelColor: Theme.of(context).primaryColor,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Theme.of(context).primaryColor,
                  ),
                ),
                pinned: true,
              ),
            ];
          },
          body: isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  key: _refreshIndicatorKey,
                  onRefresh: fetchBusInfo,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildMapView(),
                      _buildStopsView(),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildMapView() {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(busLatitude, busLongitude),
                  zoom: 15,
                ),
                markers: markers,
                polylines: polylines,
                onMapCreated: (controller) {
                  _mapController = controller;
                  setState(() {
                    isMapInitialized = true;
                  });
                },
                zoomControlsEnabled: true,
                zoomGesturesEnabled: true,
                scrollGesturesEnabled: true,
                rotateGesturesEnabled: true,
                tiltGesturesEnabled: true,
                onCameraMove: (_) {
                  setState(() {
                    _isFollowingBus = false;
                  });
                },
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.location_on,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    currentStop,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    'Next: $nextStop',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 24),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              _buildStatusIndicator(
                                'Status',
                                busStatus.replaceAll('VEHICLE_STOPSTATUS_', ''),
                                Icons.info_outline,
                              ),
                              const SizedBox(width: 24),
                              _buildStatusIndicator(
                                'Direction',
                                direction.isEmpty ? 'N/A' : direction,
                                Icons.arrow_forward,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStopsView() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Route Information',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                _buildInfoRow(
                  Icons.route,
                  'Route ID',
                  selectedRouteId,
                ),
                _buildInfoRow(
                  Icons.directions_bus,
                  'License Plate',
                  licensePlate,
                ),
                if (!isShortRoute && lastPassedStop.isNotEmpty)
                  _buildInfoRow(
                    Icons.history,
                    'Last Passed',
                    lastPassedStop,
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Remaining Stops',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              if (remainingStops.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('No stops available'),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: remainingStops.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final bool isCurrentStop = index == 0;
                    final stopName = remainingStops[index];

                    return ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isCurrentStop
                              ? Theme.of(context).primaryColor.withOpacity(0.1)
                              : Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          isCurrentStop
                              ? Icons.location_on
                              : Icons.location_on_outlined,
                          color: isCurrentStop
                              ? Theme.of(context).primaryColor
                              : Colors.grey,
                        ),
                      ),
                      title: Text(
                        stopName,
                        style: TextStyle(
                          fontWeight: isCurrentStop
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      subtitle: isCurrentStop
                          ? const Text('Current Stop')
                          : Text('Stop ${index + 1}'),
                    );
                  },
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusIndicator(String label, String value, IconData icon) {
    return SizedBox(
      width: 120,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.grey[600]),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRemainingStopsList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Remaining Stops',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        remainingStops.isEmpty
            ? const Text('No stops available')
            : SizedBox(
                height: 150,
                child: ListView.builder(
                  itemCount: remainingStops.length,
                  itemBuilder: (context, index) {
                    final bool isCurrentStop = index == 0;
                    final stopName = remainingStops[index];

                    return ListTile(
                      dense: true,
                      leading: Icon(
                        isCurrentStop
                            ? Icons.location_on
                            : Icons.location_on_outlined,
                        color: isCurrentStop ? Colors.blue : Colors.black54,
                      ),
                      title: Text(
                        stopName,
                        style: TextStyle(
                          fontWeight: isCurrentStop
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                    );
                  },
                ),
              ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Theme.of(context).primaryColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GTFSService {
  Future<Map<String, dynamic>> fetchGTFSStaticData() async {
    try {
      String stopsData = await _loadAsset('assets/gtfs/stops.txt');
      String tripsData = await _loadAsset('assets/gtfs/trips.txt');
      String stopTimesData = await _loadAsset('assets/gtfs/stop_times.txt');

      return {
        'stops': CsvToListConverter(eol: '\n').convert(stopsData),
        'trips': CsvToListConverter(eol: '\n').convert(tripsData),
        'stop_times': CsvToListConverter(eol: '\n').convert(stopTimesData),
      };
    } catch (error) {
      throw Exception('Failed to load GTFS Static Data: $error');
    }
  }

  Future<String> _loadAsset(String path) async {
    return await rootBundle.loadString(path);
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
