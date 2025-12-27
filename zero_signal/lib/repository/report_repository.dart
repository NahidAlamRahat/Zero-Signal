import 'package:zero_signal/constant/api_end_point.dart';
import 'package:zero_signal/service/api_service/api_services.dart';
import '../../utils/app_log/app_log.dart';

class ReportRepository {
  Future<bool> reportItem({
    required String reason,
    required String itemId,
    required String type,
  }) async {
    try {
      final Map<String, dynamic> payload = {
        "reson": reason,
        "item": itemId,
        "type": type,
      };

      appLog("Report Payload: $payload");

      final response = await ApiService.postApi(
        AppApiEndPoint.reportEndPoint,
        payload,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        appLog("Report failed: ${response.message}");
        return false;
      }
    } catch (e) {
      appLog("Report error: $e");
      return false;
    }
  }
}
