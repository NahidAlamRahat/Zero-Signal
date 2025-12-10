import 'package:get/get.dart';
import '../../constant/api_end_point.dart';
import '../../service/api_service/api_services.dart';

class SignUpApiController extends GetxController {
  bool _signUpInProgress = false;

  bool get signUpInProgress => _signUpInProgress;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _successfullyMessage;
  String? get successfullyMessage => _successfullyMessage;

  Future<bool> userSignUp(var signUpModel) async {
    bool isSuccess = false;
    _signUpInProgress = true;
    update();

    var response = await ApiService.postApi(
      AppApiEndPoint.signUpEndPoint,
      signUpModel,
    );

    if (response.statusCode == 200) {
      _successfullyMessage = response.message;
      isSuccess = true;
    } else {
      _errorMessage = response.message;
    }

    _signUpInProgress = false;
    update();
    return isSuccess;
  }
}
