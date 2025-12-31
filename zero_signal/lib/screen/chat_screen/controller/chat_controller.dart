import 'dart:io';

import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:zero_signal/repository/chat_repository.dart';
import 'package:zero_signal/service/sockets/app_socket_all_operation.dart';
import 'package:zero_signal/service/storage/storage_service.dart';
import 'package:zero_signal/utils/app_log/app_log.dart';
import 'package:zero_signal/utils/app_log/error_log.dart';

import '../model/chat_model.dart';

class ChatController extends GetxController {
  // --- OBSERVABLE LISTS ---
  // These lists will hold our data and notify widgets when they change.
  final RxList<Participant> participants = <Participant>[].obs;
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  AppSocketAllOperation appSocketAllOperation = AppSocketAllOperation.instance;

  final ChatRepository _repository = ChatRepository();
  String activityId = '';
  var isLoading = false.obs;

  // Voice recording
  final AudioRecorder _audioRecorder = AudioRecorder();
  var isRecording = false.obs;
  String? _recordingPath;

  // Message pagination
  int _messagePage = 1;
  bool _hasMoreMessages = true;
  bool _isLoadingMoreMessages = false;

  @override
  void onInit() {
    super.onInit();
    appLog('user id == >> ${LocalStorage.userId}');

    if (Get.arguments != null) {
      if (Get.arguments is String) {
        activityId = Get.arguments as String;
        socketHandler();
      } else if (Get.arguments is Map) {}
      fetchMessages();
      fetchMembers();
    }
  }

  @override
  void onClose() {
    _audioRecorder.dispose();
    super.onClose();
  }

  void chatMessageSocketHandler(dynamic message) {
    try {
      ChatMessage chatMessage = ChatMessage.fromJson(message);

      // If sender only has ID, try to find full details in participants list
      if (chatMessage.sender != null &&
          (chatMessage.sender!.username == null ||
              chatMessage.sender!.image == null)) {
        final fullParticipant = participants.firstWhereOrNull(
          (p) => p.id == chatMessage.sender!.id,
        );
        if (fullParticipant != null) {
          // Replace with full participant info
          chatMessage = ChatMessage(
            id: chatMessage.id,
            activity: chatMessage.activity,
            sender: fullParticipant,
            text: chatMessage.text,
            images: chatMessage.images,
            type: chatMessage.type,
            audio: chatMessage.audio,
            createdAt: chatMessage.createdAt,
          );
        }
      }

      messages.insert(0, chatMessage);
      messages.refresh();
      appLog('rahat');
    } catch (e) {
      errorLog("chatMessageSocketHandler $e");
    }
  }

  void socketHandler() {
    appLog(
        "==========================chat Socket  ============================");
    appLog("activityId====> $activityId");
    appSocketAllOperation.readEvent(
      event: "getMessage::$activityId",
      handler: (data) {
        chatMessageSocketHandler(data);
        appLog('👌👌👌👌new chat==>>> $data  ');
      },
    );
  }

  Future<void> fetchMessages({bool isLoadMore = false}) async {
    if (activityId.isEmpty) return;

    if (isLoadMore) {
      if (!_hasMoreMessages || _isLoadingMoreMessages) return;
      _isLoadingMoreMessages = true;
    } else {
      isLoading.value = true;
      _messagePage = 1;
      _hasMoreMessages = true;
    }

    final chatData = await _repository.getMessages(
      activityId: activityId,
      page: _messagePage,
    );

    if (chatData != null && chatData.messages != null) {
      if (isLoadMore) {
        messages.addAll(chatData.messages!);
      } else {
        // --- FIX: MERGE INSTEAD OF OVERWRITE ---
        // We use a Set to avoid duplicates if socket messages arrived during fetch.
        // We prioritize the existing messages (which might be newer from socket).
        final existingIds = messages.map((m) => m.id).toSet();
        final newMessages = chatData.messages!
            .where((m) => !existingIds.contains(m.id))
            .toList();
        messages.addAll(newMessages);
      }

      // Check pagination
      if (chatData.pagination != null) {
        _hasMoreMessages = _messagePage < (chatData.pagination!.totalPage ?? 1);
      } else {
        _hasMoreMessages = chatData.messages!.isNotEmpty;
      }

      if (_hasMoreMessages) {
        _messagePage++;
      }
    }

    // --- FIX: STOP LOADING AFTER DATA IS READY ---
    // We update the loading state AFTER updating the list to prevent empty frames.
    if (isLoadMore) {
      _isLoadingMoreMessages = false;
    } else {
      isLoading.value = false;
    }
  }

  Future<void> fetchMembers() async {
    if (activityId.isEmpty) return;

    final fetchedMembers = await _repository.getMembers(activityId: activityId);
    if (fetchedMembers != null) {
      participants.assignAll(fetchedMembers);
    }
  }

  bool isCurrentUser(String? senderId) {
    if (senderId == null) return false;
    appLog(
        'isCurrentUser check: senderId=$senderId, LocalStorage.userId=${LocalStorage.userId}');
    return senderId == LocalStorage.userId;
  }

  // --- METHODS TO MANIPULATE DATA ---
  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Optimistic update: add message to list immediately
    final optimisticMessage = ChatMessage(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      activity: activityId,
      sender: Participant(
        id: LocalStorage.userId,
        username: LocalStorage.myName,
        image: LocalStorage.myImage,
      ),
      text: text,
      type: 'text',
      isSending: true,
      createdAt: DateTime.now().toIso8601String(),
    );

    messages.insert(0, optimisticMessage);
    messages.refresh();

    final success = await _repository.sendMessage(
      activityId: activityId,
      type: 'text',
      text: text,
    );

    // Remove optimistic message so the one coming from socket is the only one shown
    messages.removeWhere((m) => m.id == optimisticMessage.id);
    messages.refresh();

    if (!success) {
      appLog('Failed to send message');
    }
  }

  // Placeholder for future media sending
  Future<void> sendMediaMessage(String type, File file) async {
    ChatMessage? optimisticMessage;

    if (type == 'audio') {
      optimisticMessage = ChatMessage(
        id: 'temp_audio_${DateTime.now().millisecondsSinceEpoch}',
        activity: activityId,
        sender: Participant(
          id: LocalStorage.userId,
          username: LocalStorage.myName,
          image: LocalStorage.myImage,
        ),
        type: 'audio',
        audio: file.path, // Store local path for playback
        isSending: true,
        createdAt: DateTime.now().toIso8601String(),
      );

      messages.insert(0, optimisticMessage);
      messages.refresh();
    }

    final success = await _repository.sendMessage(
      activityId: activityId,
      type: type,
      text: '',
      file: file,
    );

    if (optimisticMessage != null) {
      // Remove the optimistic message.
      // The real message will arrive via socket and be inserted.
      messages.removeWhere((m) => m.id == optimisticMessage!.id);
      messages.refresh();
    }

    if (!success && type == 'audio') {
      appLog('Failed to send audio message');
    }
  }

  // Voice recording methods
  Future<void> startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final directory = await getTemporaryDirectory();
        final path =
            '${directory.path}/audio_${DateTime.now().millisecondsSinceEpoch}.mp3';

        await _audioRecorder.start(
          const RecordConfig(encoder: AudioEncoder.aacLc),
          path: path,
        );
        _recordingPath = path;
        isRecording.value = true;
      }
    } catch (e) {
      appLog('Failed to start recording: $e',
          source: 'ChatController', type: LogType.error);
    }
  }

  Future<void> stopRecordingAndSend() async {
    try {
      await _audioRecorder.stop();
      isRecording.value = false;

      if (_recordingPath != null) {
        final file = File(_recordingPath!);
        if (await file.exists()) {
          await sendMediaMessage('audio', file);
        }
        _recordingPath = null;
      }
    } catch (e) {
      appLog('Failed to stop recording: $e',
          source: 'ChatController', type: LogType.error);
      isRecording.value = false;
    }
  }

  Future<void> cancelRecording() async {
    try {
      await _audioRecorder.stop();
      isRecording.value = false;

      if (_recordingPath != null) {
        final file = File(_recordingPath!);
        if (await file.exists()) {
          await file.delete();
        }
        _recordingPath = null;
      }
    } catch (e) {
      appLog('Failed to cancel recording: $e',
          source: 'ChatController', type: LogType.error);
      isRecording.value = false;
    }
  }
}
