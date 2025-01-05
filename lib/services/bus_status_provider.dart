import 'package:flutter/foundation.dart';
import 'package:bus_tracking_system/services/bus_status_model.dart';
import 'package:bus_tracking_system/services/bus_status_storage.dart';

class BusStatusProvider extends ChangeNotifier {
  List<BusStatus> _statusUpdates = [];

  List<BusStatus> get statusUpdates => _statusUpdates;

  Future<void> loadStatusUpdates() async {
    try {
      _statusUpdates = await BusStatusStorage.getAllStatuses();
      notifyListeners();
    } catch (e) {
      print('Error loading status updates: $e');
    }
  }

  Future<void> addStatus(BusStatus status) async {
    try {
      await BusStatusStorage.insertStatus(status);
      _statusUpdates.insert(0, status);
      notifyListeners();
    } catch (e) {
      print('Error adding status: $e');
      throw e;
    }
  }

  Future<void> deleteStatus(String busId, DateTime timestamp) async {
    try {
      await BusStatusStorage.deleteStatus(busId, timestamp);
      _statusUpdates.removeWhere(
          (status) => status.busId == busId && status.timestamp == timestamp);
      notifyListeners();
    } catch (e) {
      print('Error deleting status: $e');
      throw e;
    }
  }
}
