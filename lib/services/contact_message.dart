class ContactMessage {
  final String id;
  final String userId;
  final String userEmail;
  final String problemType;
  final String content;
  final DateTime timestamp;
  final List<MessageReply> replies;
  final bool isResolved;

  ContactMessage({
    required this.id,
    required this.userId,
    required this.userEmail,
    required this.problemType,
    required this.content,
    required this.timestamp,
    this.replies = const [],
    this.isResolved = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'userEmail': userEmail,
      'problemType': problemType,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'replies': replies.map((reply) => reply.toMap()).toList(),
      'isResolved': isResolved,
    };
  }

  factory ContactMessage.fromMap(Map<String, dynamic> map) {
    return ContactMessage(
      id: map['id'],
      userId: map['userId'],
      userEmail: map['userEmail'],
      problemType: map['problemType'],
      content: map['content'],
      timestamp: DateTime.parse(map['timestamp']),
      replies: List<MessageReply>.from(
        map['replies']?.map((x) => MessageReply.fromMap(x)) ?? [],
      ),
      isResolved: map['isResolved'] ?? false,
    );
  }
}

class MessageReply {
  final String id;
  final String adminId;
  final String content;
  final DateTime timestamp;

  MessageReply({
    required this.id,
    required this.adminId,
    required this.content,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'adminId': adminId,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory MessageReply.fromMap(Map<String, dynamic> map) {
    return MessageReply(
      id: map['id'],
      adminId: map['adminId'],
      content: map['content'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}
