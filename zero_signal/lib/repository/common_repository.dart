import '../../widget/app_snack_bar/app_snack_bar.dart';
import '../constant/api_end_point.dart';
import '../screen/disclaimer_screen/model/disclaimer_model.dart';
import '../screen/profile/faq_screen/model/faq_model.dart';
import '../service/api_service/api_services.dart';
import '../service/api_service/service_model/service_model.dart';
import '../utils/app_log/error_log.dart';

class CommonRepository {



  Future<TermsAndConditionsResponse?> fetchDisclaimerData({required String type}) async {
    try {
      final ApiResponseModel response =
          await ApiService.getApi(AppApiEndPoint.instance.disclaimer(type: type));

      if (response.statusCode == 200) {
        final body = response.body;
        if (body is Map<String, dynamic>) {
          return TermsAndConditionsResponse.fromJson(body);
        }
        AppSnackBar.error("Invalid response format received.");
        return null;
      }

      AppSnackBar.error(response.message);
      return null;
    } catch (e) {
      AppSnackBar.error("Error fetching terms and conditions: ${e.toString()}");
      return null;
    }
  }


  Future<List<FAQData>?> fetchFAQs() async {
    try {
      var response = await ApiService.getApi(AppApiEndPoint.faqEndPoint);
      FAQ faqData = FAQ.fromJson(response.body);
      return faqData.data;
    } catch (e) {
      errorLog(e);
      AppSnackBar.error("An error occurred while fetching FAQs.");
      return null;
    }
  }



}