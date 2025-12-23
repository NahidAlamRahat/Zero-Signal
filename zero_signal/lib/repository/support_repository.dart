import 'dart:io';
import 'package:zero_signal/constant/api_end_point.dart';
import 'package:zero_signal/service/api_service/api_services.dart';
import 'package:zero_signal/service/api_service/service_model/service_model.dart';

class SupportRepository {
  Future<ApiResponseModel> createSupport({
    required String message,
    List<File>? images,
  }) async {
    Map<String, String> body = {
      'message': message,
    };

    List<MultipartBody>? multipartBody;
    if (images != null && images.isNotEmpty) {
      multipartBody =
          images.map((image) => MultipartBody('image', image)).toList();
    }

    return await ApiService.postMultipartApi(
      AppApiEndPoint.supportEndPoint,
      body,
      multipartBody: multipartBody,
    );
  }
}
