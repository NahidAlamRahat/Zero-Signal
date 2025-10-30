class ChatMessage {
  final String id;
  final String userId;
  final String username;
  final String avatarUrl;
  final String text;
  final DateTime timestamp;
  final bool isCurrentUser;

  ChatMessage({
    required this.id,
    required this.userId,
    required this.username,
    required this.avatarUrl,
    required this.text,
    required this.timestamp,
    this.isCurrentUser = false,
  });
}

// Model for a participant
class Participant {
  final String userId;
  final String username;
  final String avatarUrl;
  final int age;

  Participant({
    required this.userId,
    required this.username,
    required this.avatarUrl,
    required this.age,
  });
}
