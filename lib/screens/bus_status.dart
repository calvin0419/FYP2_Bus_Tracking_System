import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bus_tracking_system/services/bus_status_provider.dart';

class BusStatusScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<BusStatusProvider>(
      builder: (context, provider, child) {
        return ListView.builder(
          itemCount: provider.statusUpdates.length,
          itemBuilder: (context, index) {
            final status = provider.statusUpdates[index];
            return Card(
              margin: EdgeInsets.all(8),
              child: ListTile(
                title: Text('Bus ${status.busId} - Route ${status.routeId}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${status.reason}: ${status.details}'),
                    Text(
                      'Posted: ${status.timestamp.toString().split('.')[0]}',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                leading: Icon(Icons.warning_rounded, color: Colors.orange),
              ),
            );
          },
        );
      },
    );
  }
}