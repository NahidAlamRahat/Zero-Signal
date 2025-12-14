/*
import 'package:get/get.dart';



class TermsAndConditionsController extends GetxController {
  final CommonRepository commonRepository = CommonRepository();
  var termsConditions = StaticPageModel().obs;
  var isLoading = false.obs;
  var data = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  void loadData() async {
    try {
      isLoading(true);
      final response = await commonRepository.fetchTermsAndConditions();
      if (response != null && response.data != null) {
        termsConditions.value = response;
        data.value = (response.data!.content ?? '')
            .replaceAll('white-space:pre-wrap;', '')
            .replaceAll('\u00A0', ' ')
            .replaceAll(RegExp(r'\s+'), ' ')
            .trim();
      } else {
        // AppSnackBar.message("Terms and conditions not found");
      }
    } catch (e) {
      errorLog("loadData");
      // AppSnackBar.error("Error fetching terms and conditions");
    } finally {
      isLoading(false);
    }
  }
}
*/
