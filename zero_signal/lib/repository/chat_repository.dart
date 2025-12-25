import 'dart:io';

import 'package:zero_signal/constant/api_end_point.dart';
import 'package:zero_signal/screen/chat_screen/model/chat_model.dart';
import 'package:zero_signal/service/api_service/api_services.dart';
import 'package:zero_signal/widget/app_snack_bar/app_snack_bar.dart';

class ChatRepository {
  Future<ChatData?> getMessages({
    required String activityId,
    int page = 1,
  }) async {
    try {
      final response = await ApiService.getApi(
        AppApiEndPoint.instance.messageEndPoint(activityId, page: page),
      );

      if (response.statusCode == 200) {
        final chatResponse =
            ChatResponse.fromJson(response.body as Map<String, dynamic>);
        return chatResponse.data;
      } else {
        AppSnackBar.error(response.message);
        return null;
      }
    } catch (e) {
      AppSnackBar.error("Failed to load messages");
      return null;
    }
  }

  Future<List<Participant>?> getMembers({required String activityId}) async {
    try {
      final response = await ApiService.getApi(
        AppApiEndPoint.instance.memberListEndPoint(activityId),
      );

      if (response.statusCode == 200) {
        final memberResponse =
            MemberResponse.fromJson(response.body as Map<String, dynamic>);
        return memberResponse.data;
      } else {
        AppSnackBar.error(response.message);
        return null;
      }
    } catch (e) {
      AppSnackBar.error("Failed to load members");
      return null;
    }
  }

  Future<bool> sendMessage({
    required String activityId,
    required String type,
    required String text,
    File? file,
  }) async {
    try {
      Map<String, dynamic> body = {
        'activity': activityId,
        'type': type,
        'text': text,
      };

      List<MultipartBody>? multipartBody;
      if (file != null) {
        String key = 'media'; // Default key for doc/audio
        if (type == 'image') {
          key = 'image';
        }
        multipartBody = [MultipartBody(key, file)];
      }

      final response = await ApiService.postMultipartApi(
        AppApiEndPoint.sendMessageEndPoint,
        body,
        multipartBody: multipartBody,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        AppSnackBar.error(response.message);
        return false;
      }
    } catch (e) {
      AppSnackBar.error("Failed to send message");
      return false;
    }
  }
}
