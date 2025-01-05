import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:bus_tracking_system/screens/gtfs-realtime.pb.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;

class BusService {
  static const String _url =
      'https://api.data.gov.my/gtfs-realtime/vehicle-position/mybas-johor/';

  static Map<String, String> stops = {};
  static Map<String, String> routes = {};
  static Map<String, String> trips = {};
  static Map<String, String> stopTimes = {};

  static Future<void> loadStaticData() async {
    await _loadStops();
    await _loadRoutes();
    await _loadTrips();
    await _loadStopTimes();
  }

  static Future<void> _loadStops() async {
    String data = await rootBundle.loadString('assets/gtfs/stops.txt');
    List<List<dynamic>> csvTable = CsvToListConverter().convert(data);

    for (var row in csvTable) {
      String stopId = row[0];
      String stopName = row[2];
      stops[stopId] = stopName;
    }
  }

  static Future<void> _loadRoutes() async {
    String data = await rootBundle.loadString('assets/gtfs/routes.txt');
    List<List<dynamic>> csvTable = CsvToListConverter().convert(data);

    for (var row in csvTable) {
      String routeId = row[0];
      String routeName = row[2];
      routes[routeId] = routeName;
    }
  }

  static Future<void> _loadTrips() async {
    String data = await rootBundle.loadString('assets/gtfs/trips.txt');
    List<List<dynamic>> csvTable = CsvToListConverter().convert(data);

    for (var row in csvTable) {
      String tripId = row[2];
      String routeId = row[0];
      trips[tripId] = routeId;
    }
  }

  static Future<void> _loadStopTimes() async {
    String data = await rootBundle.loadString('assets/gtfs/stop_times.txt');
    List<List<dynamic>> csvTable = CsvToListConverter().convert(data);

    for (var row in csvTable) {
      String tripId = row[0];
      String stopId = row[3];
      String arrivalTime = row[1];

      stopTimes['$tripId:$stopId'] = arrivalTime;
    }
  }

  Future<List<Marker>> fetchBuses() async {
    try {
      final response = await http.get(Uri.parse(_url));
      if (response.statusCode == 200) {
        final feed = FeedMessage.fromBuffer(response.bodyBytes);

        List<Marker> markers = [];
        for (var entity in feed.entity) {
          if (entity.vehicle != null) {
            var vehicle = entity.vehicle!;
            var position = vehicle.position;

            String routeName = routes[vehicle.trip.routeId] ?? 'Unknown Route';
            String stopName = stops[vehicle.stopId] ?? 'Unknown Stop';
            String arrivalTime = stopTimes['${vehicle.trip.tripId}:${vehicle.stopId}'] ?? 'N/A';

            markers.add(Marker(
              markerId: MarkerId(vehicle.vehicle.id),
              position: LatLng(position.latitude, position.longitude),
              infoWindow: InfoWindow(
                title: 'Vehicle ${vehicle.vehicle.id} - $routeName',
                snippet: 'Congestion: ${vehicle.congestionLevel}, Status: ${vehicle.currentStatus}\n'
                          'Next Stop: $stopName\nArrival Time: $arrivalTime',
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
            ));
          }
        }

        return markers;
      } else {
        throw Exception('Failed to load bus data');
      }
    } catch (e) {
      print('Error fetching data: $e');
      return [];
    }
  }
}
