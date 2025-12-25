import 'package:flutter/foundation.dart';
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
  void sendMessage(String text) {
    // Optimistic update or call API (API not provided yet for sending)
    /*
    final newMessage = ChatMessage(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      text: text,
      timestamp: DateTime.now(),
      sender: Participant(
        id: LocalStorage.userId,
        name: LocalStorage.myName,
        image: LocalStorage.myImage,
      ),
    );
    messages.insert(0, newMessage);
    */
    // For now, doing nothing as API is missing
    if (kDebugMode) {
      print("Sending message: $text (API not implemented)");
    }
  }
}
