import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../constant/api_end_point.dart';
import '../../service/api_service/api_services.dart';

class ForgotPassRepository extends GetxController {
  bool _inProgress = false;

  bool get inProgress => _inProgress;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _successfullyMessage;
  String? get successfullyMessage => _successfullyMessage;

  Future<bool> forgotPass({required String email}) async {
    bool isSuccess = false;
    _inProgress = true;
    update();

    var response = await ApiService.postApi(
      AppApiEndPoint.forgotPassEndPoint,
      {
        "email": email,
      },
    );

    if (response.statusCode == 200) {
      _successfullyMessage = response.message;
      isSuccess = true;
    } else {
      _errorMessage = response.message;
    }

    _inProgress = false;
    update();
    return isSuccess;
  }
}