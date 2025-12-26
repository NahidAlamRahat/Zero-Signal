import 'dart:io';

import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:zero_signal/repository/chat_repository.dart';
import 'package:zero_signal/service/storage/storage_service.dart';
import 'package:zero_signal/utils/app_log/app_log.dart';

import '../model/chat_model.dart';

class ChatController extends GetxController {
  // --- OBSERVABLE LISTS ---
  // These lists will hold our data and notify widgets when they change.
  final RxList<Participant> participants = <Participant>[].obs;
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;

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
    if (Get.arguments != null) {
      if (Get.arguments is String) {
        activityId = Get.arguments as String;
      } else if (Get.arguments is Map) {

      }
      fetchMessages();
      fetchMembers();
    }
  }

  @override
  void onClose() {
    _audioRecorder.dispose();
    super.onClose();
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

    if (isLoadMore) {
      _isLoadingMoreMessages = false;
    } else {
      isLoading.value = false;
    }

    if (chatData != null && chatData.messages != null) {
      if (isLoadMore) {
        messages.addAll(chatData.messages!);
      } else {
        messages.assignAll(chatData.messages!);
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
      appLog('Failed to start recording: $e', source: 'ChatController', type: LogType.error);
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
      appLog('Failed to stop recording: $e', source: 'ChatController', type: LogType.error);
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
      appLog('Failed to cancel recording: $e', source: 'ChatController', type: LogType.error);
      isRecording.value = false;
    }
  }
}
