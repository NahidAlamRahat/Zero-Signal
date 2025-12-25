import 'dart:io';

import 'package:get/get.dart';
import 'package:zero_signal/repository/chat_repository.dart';
import 'package:zero_signal/service/storage/storage_service.dart';

import '../model/chat_model.dart';

class ChatController extends GetxController {
  // --- OBSERVABLE LISTS ---
  // These lists will hold our data and notify widgets when they change.
  final RxList<Participant> participants = <Participant>[].obs;
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;

  final ChatRepository _repository = ChatRepository();
  String activityId = '';
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      if (Get.arguments is String) {
        activityId = Get.arguments as String;
      } else if (Get.arguments is Map) {
        // Handle if passed as map, though ActivityCard uses String or Object?
        // We will update ActivityCard to pass ID specifically or handle object here.
        // If ActivityCard passes ActivityItem, we extract ID.
        // Based on ActivityCard analysis, we should change it to pass just ID or we handle it here.
        // Let's assume we update ActivityCard to pass ID.
      }
      fetchMessages();
      fetchMembers();
    }
  }

  Future<void> fetchMessages() async {
    if (activityId.isEmpty) return;

    isLoading.value = true;
    final fetchedMessages =
        await _repository.getMessages(activityId: activityId);
    isLoading.value = false;

    if (fetchedMessages != null) {
      messages.assignAll(fetchedMessages);
    }
  }

  Future<void> fetchMembers() async {
    if (activityId.isEmpty) return;

    final fetchedMembers = await _repository.getMembers(activityId: activityId);
    if (fetchedMembers != null) {
      participants.assignAll(fetchedMembers);
    }
  }

  bool isCurrentUser(String? userId) {
    if (userId == null) return false;
    return userId == LocalStorage.userId;
  }

  // --- METHODS TO MANIPULATE DATA ---
  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Optimistic update can be tricky with IDs, so for now we'll just wait for API
    // Or we could append local message then refresh.
    // Let's stick to API call first.

    final success = await _repository.sendMessage(
      activityId: activityId,
      type: 'text',
      text: text,
    );

    if (success) {
      // Refresh messages to show the new one
      // In a real socket app, we wouldn't need this manually usually.
      // Message clearing handled in UI
      fetchMessages();
    }
  }

  // Placeholder for future media sending
  Future<void> sendMediaMessage(String type, File file) async {
    final success = await _repository.sendMessage(
      activityId: activityId,
      type: type,
      text: '',
      file: file,
    );

    if (success) {
      fetchMessages();
    }
  }
}
