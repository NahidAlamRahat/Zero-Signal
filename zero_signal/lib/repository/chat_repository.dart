import 'package:zero_signal/constant/api_end_point.dart';
import 'package:zero_signal/screen/chat_screen/model/chat_model.dart';
import 'package:zero_signal/service/api_service/api_services.dart';
import 'package:zero_signal/widget/app_snack_bar/app_snack_bar.dart';

class ChatRepository {
  Future<List<ChatMessage>?> getMessages({required String activityId}) async {
    try {
      final response = await ApiService.getApi(
        AppApiEndPoint.instance.messageEndPoint(activityId),
      );

      if (response.statusCode == 200) {
        final chatResponse =
            ChatResponse.fromJson(response.body as Map<String, dynamic>);
        return chatResponse.data?.messages;
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
}
