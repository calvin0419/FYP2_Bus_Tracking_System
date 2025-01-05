import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:bus_tracking_system/screens/gtfs-realtime.pb.dart';
import 'bus_info.dart';
import 'admin_dashboard.dart';

class BusListScreen extends StatefulWidget {
  const BusListScreen({super.key});

  @override
  _BusListScreenState createState() => _BusListScreenState();
}

class _BusListScreenState extends State<BusListScreen> {
  Map<String, List<VehiclePosition>> groupedBuses = {};
  Map<String, List<VehiclePosition>> filteredBuses = {};
  String searchQuery = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRealtimeData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> fetchRealtimeData() async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.data.gov.my/gtfs-realtime/vehicle-position/mybas-johor/'));
      if (response.statusCode == 200) {
        final feed = FeedMessage.fromBuffer(response.bodyBytes);

        final Map<String, List<VehiclePosition>> grouped = {};
        for (var entity in feed.entity) {
          if (entity.vehicle != null) {
            final vehicle = entity.vehicle!;
            final routeId = vehicle.trip.routeId;
            grouped.putIfAbsent(routeId, () => []).add(vehicle);
          }
        }

        setState(() {
          groupedBuses = grouped;
          applySearch();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void applySearch() {
    if (searchQuery.isEmpty) {
      final Map<String, List<VehiclePosition>> filtered = {};
      groupedBuses.forEach((routeId, buses) {
        final activeBuses = buses
            .where((bus) => BusActiveStatus.isBusActive(bus.vehicle.id))
            .toList();
        if (activeBuses.isNotEmpty) {
          filtered[routeId] = activeBuses;
        }
      });
      filteredBuses = filtered;
    } else {
      final Map<String, List<VehiclePosition>> filtered = {};
      groupedBuses.forEach((routeId, buses) {
        final matchingBuses = buses.where((bus) {
          final licensePlate = bus.vehicle.licensePlate ?? '';
          final isActive = BusActiveStatus.isBusActive(bus.vehicle.id);
          return isActive &&
              (routeId.toLowerCase().contains(searchQuery.toLowerCase()) ||
                  licensePlate
                      .toLowerCase()
                      .contains(searchQuery.toLowerCase()));
        }).toList();
        if (matchingBuses.isNotEmpty) {
          filtered[routeId] = matchingBuses;
        }
      });
      setState(() {
        filteredBuses = filtered;
      });
    }
  }

  String _formatDelayMessage(int delayInSeconds) {
    if (delayInSeconds < 60) return 'On time';
    final minutes = delayInSeconds ~/ 60;
    if (minutes < 60) return '$minutes min delay';
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    return '${hours}h ${remainingMinutes}m delay';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Live Bus',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchRealtimeData,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search routes or bus numbers',
                hintStyle: TextStyle(color: Colors.grey[300]),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                filled: true,
                fillColor: Colors.white.withOpacity(0.2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
              ),
              style: const TextStyle(color: Colors.white),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.trim();
                  applySearch();
                });
              },
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : filteredBuses.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.no_transfer,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No buses found',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filteredBuses.length,
                        itemBuilder: (context, index) {
                          final routeId = filteredBuses.keys.elementAt(index);
                          final buses = filteredBuses[routeId]!;

                          return Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: ExpansionTile(
                              leading: CircleAvatar(
                                backgroundColor: Theme.of(context).primaryColor,
                                child: Text(
                                  buses.length.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(
                                'Route $routeId',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              subtitle: Text(
                                '${buses.length} active buses',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              children: buses.map((bus) {
                                final busId = bus.vehicle.id;
                                final currentTime =
                                    DateTime.now().millisecondsSinceEpoch ~/
                                        1000;
                                final busTimestamp = bus.timestamp.toInt();
                                final delayInSeconds =
                                    currentTime - busTimestamp;
                                final delayMessage =
                                    _formatDelayMessage(delayInSeconds);
                                final isDelayed = delayInSeconds >= 60;

                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => BusInfoScreen(
                                          routeId: routeId,
                                          busId: busId,
                                          licensePlate:
                                              bus.vehicle.licensePlate,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        top: BorderSide(
                                          color: Colors.grey[200]!,
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: isDelayed
                                                ? Colors.red[50]
                                                : Colors.green[50],
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Icon(
                                            Icons.directions_bus,
                                            color: isDelayed
                                                ? Colors.red
                                                : Colors.green,
                                            size: 24,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Bus $busId',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                delayMessage,
                                                style: TextStyle(
                                                  color: isDelayed
                                                      ? Colors.red
                                                      : Colors.green,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          size: 16,
                                          color: Colors.grey[400],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
