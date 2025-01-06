import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:bus_tracking_system/screens/gtfs-realtime.pb.dart';
import 'dart:async';
import 'package:bus_tracking_system/services/bus_status_model.dart';
import 'package:bus_tracking_system/services/bus_status_storage.dart';
import 'package:provider/provider.dart';
import 'package:bus_tracking_system/services/bus_status_provider.dart';
import 'package:bus_tracking_system/services/contact_message.dart';
import 'package:bus_tracking_system/services/contact_service.dart';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class BusActiveStatus {
  static final Map<String, bool> _busStatus = {};

  static void setBusStatus(String busId, bool isActive) {
    _busStatus[busId] = isActive;
  }

  static bool isBusActive(String busId) {
    return _busStatus[busId] ?? true;
  }
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;
  int totalActiveBuses = 0;
  int totalRealtimeBuses = 0;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    await _loadActiveBuses();
    await _loadRealtimeBuses();
    setState(() {});
  }

  Future<void> _loadActiveBuses() async {
    totalActiveBuses = await fetchActiveBuses();
  }

  Future<void> _loadRealtimeBuses() async {
    totalRealtimeBuses = await fetchRealtimeVehiclePositions();
  }

  Future<int> fetchActiveBuses() async {
    final data = await rootBundle.loadString('assets/gtfs/trips.txt');
    List<List<dynamic>> rows = const CsvToListConverter().convert(data);
    int activeBusCount = 0;

    for (var row in rows.skip(1)) {
      print(row);
      if (row[0] != null && row[1] != 'CANCELLED') {
        activeBusCount++;
      }
    }
    return activeBusCount;
  }

  Future<int> fetchRealtimeVehiclePositions() async {
    final response = await http.get(Uri.parse(
        'https://api.data.gov.my/gtfs-realtime/vehicle-position/mybas-johor/'));
    if (response.statusCode == 200) {
      final feed = FeedMessage.fromBuffer(response.bodyBytes);
      return feed.entity.length;
    } else {
      throw Exception('Failed to load GTFS Realtime data');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      AdminDashboardContent(
        totalActiveBuses: totalActiveBuses,
        totalRealtimeBuses: totalRealtimeBuses,
      ),
      BusManagementScreen(),
      UploadBusStatusScreen(),
      ContactReceiveScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Logout'),
                  content: Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushReplacementNamed(context, '/');
                      },
                      child: Text('Logout'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.grey,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_rounded),
              activeIcon: Icon(Icons.dashboard_rounded),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.directions_bus_outlined),
              activeIcon: Icon(Icons.directions_bus_rounded),
              label: 'Buses',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bus_alert_outlined),
              activeIcon: Icon(Icons.bus_alert_rounded),
              label: 'Bus Status',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.mail_outlined),
              activeIcon: Icon(Icons.mail_rounded),
              label: 'Messages',
            ),
          ],
        ),
      ),
    );
  }
}

class AdminDashboardContent extends StatelessWidget {
  final int totalActiveBuses;
  final int totalRealtimeBuses;

  AdminDashboardContent({
    required this.totalActiveBuses,
    required this.totalRealtimeBuses,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryCard(
            context,
            title: 'Realtime Active Buses',
            value: totalRealtimeBuses.toString(),
            icon: Icons.location_on,
            color: Colors.green,
          ),
          SizedBox(height: 16),
          _buildSummaryCard(
            context,
            title: 'Today\'s Trips',
            value: '150',
            icon: Icons.timeline,
            color: Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BusManagementScreen extends StatefulWidget {
  @override
  _BusManagementScreenState createState() => _BusManagementScreenState();
}

class _BusManagementScreenState extends State<BusManagementScreen> {
  Map<String, List<VehiclePosition>> groupedBuses = {};
  Map<String, List<VehiclePosition>> filteredBuses = {};
  late Timer _timer;
  String searchQuery = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRealtimeData();
    _timer = Timer.periodic(const Duration(seconds: 30), (Timer t) {
      fetchRealtimeData();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
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
      filteredBuses = groupedBuses;
    } else {
      final Map<String, List<VehiclePosition>> filtered = {};
      groupedBuses.forEach((routeId, buses) {
        final matchingBuses = buses.where((bus) {
          final licensePlate = bus.vehicle.licensePlate ?? '';
          return routeId.toLowerCase().contains(searchQuery.toLowerCase()) ||
              licensePlate.toLowerCase().contains(searchQuery.toLowerCase());
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

  Widget _buildBusCard(VehiclePosition bus, String routeId) {
    final busId = bus.vehicle.id;
    final currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final busTimestamp = bus.timestamp.toInt();
    final delayInSeconds = currentTime - busTimestamp;
    final delayMessage = _formatDelayMessage(delayInSeconds);
    final isDelayed = delayInSeconds >= 60;
    final isActive = BusActiveStatus.isBusActive(busId);

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isDelayed ? Colors.red[50] : Colors.green[50],
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            Icons.directions_bus,
            color: isDelayed ? Colors.red : Colors.green,
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                    color: isDelayed ? Colors.red : Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: isActive,
            onChanged: (bool value) {
              setState(() {
                BusActiveStatus.setBusStatus(busId, value);
              });
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
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
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Route $routeId',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${buses.length} active buses',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                  const SizedBox(height: 16),
                                  Column(
                                    children: buses
                                        .map((bus) =>
                                            _buildBusCard(bus, routeId))
                                        .toList(),
                                  ),
                                ],
                              ),
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

class UploadBusStatusScreen extends StatefulWidget {
  @override
  _UploadBusStatusScreenState createState() => _UploadBusStatusScreenState();
}

class _UploadBusStatusScreenState extends State<UploadBusStatusScreen> {
  final _formKey = GlobalKey<FormState>();
  Map<String, VehiclePosition> availableBuses = {};
  VehiclePosition? selectedBus;
  String? selectedReason;
  final TextEditingController _detailsController = TextEditingController();
  List<BusStatus> statusUpdates = [];
  bool isLoading = true;

  final List<String> reasons = [
    'Mechanical Issue',
    'Accident',
    'Scheduled Maintenance',
    'Driver Unavailable',
    'Weather Conditions',
    'Route Blocked',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await fetchRealtimeBuses();
    await loadStatusUpdates();
  }

  Future<void> loadStatusUpdates() async {
    try {
      final updates = await BusStatusStorage.getAllStatuses();
      setState(() {
        statusUpdates = updates;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading status updates: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchRealtimeBuses() async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.data.gov.my/gtfs-realtime/vehicle-position/mybas-johor/'));

      if (response.statusCode == 200) {
        final feed = FeedMessage.fromBuffer(response.bodyBytes);
        final Map<String, VehiclePosition> buses = {};

        for (var entity in feed.entity) {
          if (entity.vehicle != null) {
            final vehicle = entity.vehicle!;
            buses[vehicle.vehicle.id] = vehicle;
          }
        }

        setState(() {
          availableBuses = buses;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load GTFS Realtime data');
      }
    } catch (e) {
      print('Error fetching buses: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _submitStatus() async {
    if (_formKey.currentState!.validate() && selectedBus != null) {
      final newStatus = BusStatus(
        busId: selectedBus!.vehicle.id,
        routeId: selectedBus!.trip.routeId,
        reason: selectedReason!,
        details: _detailsController.text,
        timestamp: DateTime.now(),
        status: 'Inactive',
      );

      try {
        final provider = Provider.of<BusStatusProvider>(context, listen: false);

        await provider.addStatus(newStatus);

        setState(() {
          BusActiveStatus.setBusStatus(selectedBus!.vehicle.id, false);
          selectedBus = null;
          selectedReason = null;
          _detailsController.clear();
        });

        await loadStatusUpdates();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Status update posted successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving status update'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _deleteStatus(BusStatus status) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this status update?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  final provider =
                      Provider.of<BusStatusProvider>(context, listen: false);

                  await provider.deleteStatus(status.busId, status.timestamp);

                  setState(() {
                    BusActiveStatus.setBusStatus(status.busId, true);
                  });

                  Navigator.of(context).pop();
                  await loadStatusUpdates();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Status update deleted successfully'),
                      backgroundColor: Colors.blue,
                    ),
                  );
                } catch (e) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error deleting status update'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Text('Delete'),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Update Bus Status',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 16),
                              DropdownButtonFormField<VehiclePosition>(
                                value: selectedBus,
                                decoration: InputDecoration(
                                  labelText: 'Select Bus',
                                  border: OutlineInputBorder(),
                                ),
                                items: availableBuses.values.map((bus) {
                                  return DropdownMenuItem(
                                    value: bus,
                                    child: Text(
                                        'Bus ${bus.vehicle.id} - Route ${bus.trip.routeId}'),
                                  );
                                }).toList(),
                                validator: (value) {
                                  if (value == null)
                                    return 'Please select a bus';
                                  return null;
                                },
                                onChanged: (value) {
                                  setState(() {
                                    selectedBus = value;
                                  });
                                },
                              ),
                              SizedBox(height: 16),
                              DropdownButtonFormField<String>(
                                value: selectedReason,
                                decoration: InputDecoration(
                                  labelText: 'Reason for Inactivity',
                                  border: OutlineInputBorder(),
                                ),
                                items: reasons.map((reason) {
                                  return DropdownMenuItem(
                                    value: reason,
                                    child: Text(reason),
                                  );
                                }).toList(),
                                validator: (value) {
                                  if (value == null)
                                    return 'Please select a reason';
                                  return null;
                                },
                                onChanged: (value) {
                                  setState(() {
                                    selectedReason = value;
                                  });
                                },
                              ),
                              SizedBox(height: 16),
                              TextFormField(
                                controller: _detailsController,
                                decoration: InputDecoration(
                                  labelText: 'Additional Details',
                                  border: OutlineInputBorder(),
                                ),
                                maxLines: 3,
                                validator: (value) {
                                  if (selectedReason == 'Other' &&
                                      (value == null || value.isEmpty)) {
                                    return 'Please provide additional details for Other reason';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 16),
                              SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: _submitStatus,
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 12),
                                      child: Text('Post Status Update'),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Recent Status Updates',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: statusUpdates.length,
                      itemBuilder: (context, index) {
                        final status = statusUpdates[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            title: Text(
                              'Bus ${status.busId} - Route ${status.routeId}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${status.reason}: ${status.details}'),
                                Text(
                                  'Posted: ${status.timestamp.toString().split('.')[0]}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            leading: Icon(
                              Icons.warning_rounded,
                              color: Colors.orange,
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteStatus(status),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }
}

class ContactReceiveScreen extends StatefulWidget {
  @override
  _ContactReceiveScreenState createState() => _ContactReceiveScreenState();
}

class _ContactReceiveScreenState extends State<ContactReceiveScreen> {
  List<ContactMessage> messages = [];
  bool isLoading = true;
  final TextEditingController _replyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    try {
      final allMessages = await ContactService.getAllMessages();
      setState(() {
        messages = allMessages
          ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
        isLoading = false;
      });
    } catch (e) {
      print('Error loading messages: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showReplyDialog(ContactMessage message) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          constraints: BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reply to Message',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.userEmail,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                      SizedBox(height: 8),
                      Text(message.content),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                TextField(
                  controller: _replyController,
                  decoration: InputDecoration(
                    labelText: 'Your reply',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                  ),
                  maxLines: 4,
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _replyController.clear();
                      },
                      child: Text('Cancel'),
                    ),
                    SizedBox(width: 8),
                    FilledButton(
                      onPressed: () async {
                        if (_replyController.text.isNotEmpty) {
                          final reply = MessageReply(
                            id: DateTime.now()
                                .millisecondsSinceEpoch
                                .toString(),
                            adminId: 'admin',
                            content: _replyController.text,
                            timestamp: DateTime.now(),
                          );

                          try {
                            await ContactService.addReply(message.id, reply);
                            Navigator.pop(context);
                            _replyController.clear();
                            _loadMessages();

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Reply sent successfully'),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.green,
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Failed to send reply'),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                      child: Text('Send Reply'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: messages.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.mark_email_unread_outlined,
                    size: 64,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No messages yet',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'New messages will appear here',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return Card(
                  elevation: 0,
                  margin: EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      dividerColor: Colors.transparent,
                    ),
                    child: ExpansionTile(
                      tilePadding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      title: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              message.problemType,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      subtitle: Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Row(
                          children: [
                            Icon(
                              Icons.mail_outline,
                              size: 16,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                message.userEmail,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                      children: [
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .surfaceVariant,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.schedule,
                                          size: 16,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          message.timestamp
                                              .toString()
                                              .split('.')[0],
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 12),
                                    Text(message.content),
                                  ],
                                ),
                              ),
                              if (message.replies.isNotEmpty) ...[
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  child: Text(
                                    'Replies',
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                ),
                                ...message.replies.map((reply) => Container(
                                      margin: EdgeInsets.only(
                                        left: 16,
                                        bottom: 12,
                                      ),
                                      padding: EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondaryContainer
                                            .withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.schedule,
                                                size: 16,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                reply.timestamp
                                                    .toString()
                                                    .split('.')[0],
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall,
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          Text(reply.content),
                                        ],
                                      ),
                                    )),
                              ],
                              SizedBox(height: 16),
                              FilledButton.icon(
                                onPressed: () => _showReplyDialog(message),
                                icon: Icon(Icons.reply),
                                label: Text('Reply'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }
}
