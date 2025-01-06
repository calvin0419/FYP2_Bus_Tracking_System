import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:bus_tracking_system/services/contact_message.dart';
import 'package:bus_tracking_system/services/contact_service.dart';

class UserMessagesScreen extends StatefulWidget {
  @override
  _UserMessagesScreenState createState() => _UserMessagesScreenState();
}

class _UserMessagesScreenState extends State<UserMessagesScreen> {
  List<ContactMessage> userMessages = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserMessages();
  }

  Future<void> _loadUserMessages() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');

      if (userId != null) {
        final messages = await ContactService.getUserMessages(userId);
        setState(() {
          userMessages = messages
            ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      print('Error loading messages: $e');
      setState(() => isLoading = false);
    }
  }

  String _getTimeAgo(DateTime timestamp) {
    return timeago.format(timestamp, allowFromNow: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'Messages',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
            )
          : CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      '${userMessages.length} ${userMessages.length == 1 ? 'Message' : 'Messages'}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ),
                userMessages.isEmpty
                    ? SliverFillRemaining(
                        child: _buildEmptyState(),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) =>
                              _buildMessageCard(userMessages[index]),
                          childCount: userMessages.length,
                        ),
                      ),
              ],
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.mark_email_unread_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'No messages yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Your messages will appear here',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageCard(ContactMessage message) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          tilePadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          childrenPadding: EdgeInsets.zero,
          leading: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: message.replies.isEmpty
                  ? Colors.orange[50]
                  : Colors.green[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              message.replies.isEmpty
                  ? Icons.mark_email_unread_rounded
                  : Icons.mark_email_read_rounded,
              color: message.replies.isEmpty
                  ? Colors.orange[700]
                  : Colors.green[700],
            ),
          ),
          title: Text(
            message.problemType,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          subtitle: Text(
            _getTimeAgo(message.timestamp),
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMessageSection(
                    'Your Message',
                    message.content,
                    Colors.grey[100]!,
                  ),
                  if (message.replies.isNotEmpty) ...[
                    SizedBox(height: 20),
                    ...message.replies.map(
                      (reply) => _buildMessageSection(
                        'Admin Reply',
                        reply.content,
                        Colors.blue[50]!,
                        timestamp: reply.timestamp,
                      ),
                    ),
                  ] else
                    _buildAwaitingResponse(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageSection(
      String title, String content, Color backgroundColor,
      {DateTime? timestamp}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
            fontSize: 14,
          ),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: backgroundColor.darken(0.1),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                content,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[800],
                  height: 1.5,
                ),
              ),
              if (timestamp != null) ...[
                SizedBox(height: 8),
                Text(
                  _getTimeAgo(timestamp),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAwaitingResponse() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.orange[100]!,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.access_time_rounded,
              size: 20,
              color: Colors.orange[700],
            ),
          ),
          SizedBox(width: 12),
          Text(
            'Awaiting admin response',
            style: TextStyle(
              color: Colors.orange[800],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

extension ColorExtension on Color {
  Color darken([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}
