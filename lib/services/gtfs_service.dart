import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:csv/csv.dart';

class GTFSService {
  Future<Map<String, dynamic>> fetchGTFSStaticData(String gtfsStaticUrl) async {
    try {
      final response = await http.get(Uri.parse(gtfsStaticUrl));
      if (response.statusCode == 200) {
        var stopsData = await parseCSV(response.body, 'stops.txt');
        var routesData = await parseCSV(response.body, 'routes.txt');
        var tripsData = await parseCSV(response.body, 'trips.txt');
        var stopTimesData = await parseCSV(response.body, 'stop_times.txt');

        return {
          'stops': stopsData,
          'routes': routesData,
          'trips': tripsData,
          'stop_times': stopTimesData,
        };
      } else {
        throw Exception('Failed to load GTFS static data');
      }
    } catch (error) {
      print('Error fetching GTFS static data: $error');
      throw error;
    }
  }

  Future<List<List<dynamic>>> parseCSV(String data, String filename) async {
    return CsvToListConverter().convert(data);
  }
}
