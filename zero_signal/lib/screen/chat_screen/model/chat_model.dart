class ChatResponse {
  final bool? success;
  final String? message;
  final ChatData? data;

  ChatResponse({this.success, this.message, this.data});

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null ? ChatData.fromJson(json['data']) : null,
    );
  }
}

class ChatData {
  final List<ChatMessage>? messages;
  final MessagePagination? pagination;

  ChatData({this.messages, this.pagination});

  factory ChatData.fromJson(Map<String, dynamic> json) {
    return ChatData(
      messages: json['messages'] != null
          ? (json['messages'] as List)
              .map((e) => ChatMessage.fromJson(e))
              .toList()
          : null,
      pagination: json['pagination'] != null
          ? MessagePagination.fromJson(json['pagination'])
          : null,
    );
  }
}

class MessagePagination {
  final int? total;
  final int? limit;
  final int? page;
  final int? totalPage;

  MessagePagination({this.total, this.limit, this.page, this.totalPage});

  factory MessagePagination.fromJson(Map<String, dynamic> json) {
    return MessagePagination(
      total: json['total'],
      limit: json['limit'],
      page: json['page'],
      totalPage: json['totalPage'],
    );
  }
}

class MemberResponse {
  final bool? success;
  final String? message;
  final List<Participant>? data;

  MemberResponse({this.success, this.message, this.data});

  factory MemberResponse.fromJson(Map<String, dynamic> json) {
    return MemberResponse(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null
          ? (json['data'] as List).map((e) => Participant.fromJson(e)).toList()
          : null,
    );
  }
}

class ChatMessage {
  final String? id;
  final String? activity;
  final Participant? sender;
  final String? text;
  final List<String>? images;
  final String? type; // 'text', 'audio', etc.
  final String? audio;
  final String? createdAt;
  final bool? isCurrentUser; // Logic to set this will be in controller/repo
  final bool isSending;

  ChatMessage({
    this.id,
    this.activity,
    this.sender,
    this.text,
    this.images,
    this.type,
    this.audio,
    this.createdAt,
    this.isCurrentUser,
    this.isSending = false,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['_id'],
      activity: json['activity'],
      sender:
          json['sender'] != null ? Participant.fromJson(json['sender']) : null,
      text: json['text'],
      images: json['images'] != null ? List<String>.from(json['images']) : [],
      type: json['type'],
      audio: json['audio'],
      createdAt: json['createdAt'],
    );
  }
}

class Participant {
  final String? id;
  final String? name;
  final String? email;
  final String? image;
  final String? username;

  Participant({
    this.id,
    this.name,
    this.email,
    this.image,
    this.username,
  });

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      image: json['image'],
      username: json['username'],
    );
  }
}
