class BusStatus {
  final String busId;
  final String routeId;
  final String reason;
  final String details;
  final DateTime timestamp;
  final String status;

  BusStatus({
    required this.busId,
    required this.routeId,
    required this.reason,
    required this.details,
    required this.timestamp,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'busId': busId,
      'routeId': routeId,
      'reason': reason,
      'details': details,
      'timestamp': timestamp.toIso8601String(),
      'status': status,
    };
  }

  factory BusStatus.fromJson(Map<String, dynamic> json) {
    return BusStatus(
      busId: json['busId'],
      routeId: json['routeId'],
      reason: json['reason'],
      details: json['details'],
      timestamp: DateTime.parse(json['timestamp']),
      status: json['status'],
    );
  }
}