import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bus_tracking_system/services/bus_status_provider.dart';
import 'package:bus_tracking_system/services/bus_status_model.dart';
import 'package:intl/intl.dart';

class BusStatusScreen extends StatefulWidget {
  @override
  _BusStatusScreenState createState() => _BusStatusScreenState();
}

class _BusStatusScreenState extends State<BusStatusScreen> {
  @override
  void initState() {
    super.initState();
    // Load status updates when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BusStatusProvider>(context, listen: false).loadStatusUpdates();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bus Status Updates'),
        elevation: 0,
      ),
      body: Consumer<BusStatusProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.statusUpdates.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.directions_bus_outlined, 
                    size: 64, 
                    color: Colors.grey[400]
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No status updates available',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.refreshStatusUpdates(),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: provider.statusUpdates.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final status = provider.statusUpdates[index];
                
                Color statusColor;
                IconData statusIcon;
                switch (status.reason.toLowerCase()) {
                  case 'mechanical issue':
                    statusColor = Colors.red;
                    statusIcon = Icons.build;
                    break;
                  case 'accident':
                    statusColor = Colors.red;
                    statusIcon = Icons.warning;
                    break;
                  case 'scheduled maintenance':
                    statusColor = Colors.orange;
                    statusIcon = Icons.schedule;
                    break;
                  case 'driver unavailable':
                    statusColor = Colors.orange;
                    statusIcon = Icons.person_off;
                    break;
                  case 'weather conditions':
                    statusColor = Colors.blue;
                    statusIcon = Icons.wb_cloudy;
                    break;
                  case 'route blocked':
                    statusColor = Colors.orange;
                    statusIcon = Icons.block;
                    break;
                  default:
                    statusColor = Colors.grey;
                    statusIcon = Icons.info_outline;
                }

                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: Colors.grey.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        builder: (context) => _buildDetailsSheet(context, status),
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(statusIcon, 
                              color: statusColor,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Bus ${status.busId}',
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: statusColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        'Route ${status.routeId}',
                                        style: TextStyle(
                                          color: statusColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  status.details,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _formatTimestamp(status.timestamp),
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return DateFormat('MMM d, h:mm a').format(timestamp);
    }
  }

  Widget _buildDetailsSheet(BuildContext context, BusStatus status) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Status Details',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 24),
          _buildDetailRow(
            context,
            'Bus Number',
            status.busId.toString(),
            Icons.directions_bus,
          ),
          const SizedBox(height: 16),
          _buildDetailRow(
            context,
            'Route',
            status.routeId.toString(),
            Icons.route,
          ),
          const SizedBox(height: 16),
          _buildDetailRow(
            context,
            'Status Type',
            status.reason,
            Icons.info_outline,
          ),
          const SizedBox(height: 16),
          _buildDetailRow(
            context,
            'Time',
            DateFormat('MMM d, y h:mm a').format(status.timestamp),
            Icons.access_time,
          ),
          const SizedBox(height: 24),
          Text(
            'Description',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            status.details,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            Text(
              value,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}