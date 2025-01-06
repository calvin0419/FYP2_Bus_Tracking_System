import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'contact_message.dart';

class ContactService {
  static const String _storageKey = 'contact_messages';

  static Future<void> saveMessage(ContactMessage message) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> messages = prefs.getStringList(_storageKey) ?? [];
    messages.add(jsonEncode(message.toMap()));
    await prefs.setStringList(_storageKey, messages);
  }

  static Future<List<ContactMessage>> getAllMessages() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> messages = prefs.getStringList(_storageKey) ?? [];
    return messages
        .map((str) => ContactMessage.fromMap(jsonDecode(str)))
        .toList();
  }

  static Future<List<ContactMessage>> getUserMessages(String userId) async {
    final messages = await getAllMessages();
    return messages.where((msg) => msg.userId == userId).toList();
  }

  static Future<void> addReply(String messageId, MessageReply reply) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> messages = prefs.getStringList(_storageKey) ?? [];

    List<ContactMessage> messageList =
        messages.map((str) => ContactMessage.fromMap(jsonDecode(str))).toList();

    int index = messageList.indexWhere((msg) => msg.id == messageId);
    if (index != -1) {
      var message = messageList[index];
      var updatedReplies = List<MessageReply>.from(message.replies)..add(reply);

      messageList[index] = ContactMessage(
        id: message.id,
        userId: message.userId,
        userEmail: message.userEmail,
        problemType: message.problemType,
        content: message.content,
        timestamp: message.timestamp,
        replies: updatedReplies,
        isResolved: message.isResolved,
      );

      await prefs.setStringList(
        _storageKey,
        messageList.map((msg) => jsonEncode(msg.toMap())).toList(),
      );
    }
  }
}
