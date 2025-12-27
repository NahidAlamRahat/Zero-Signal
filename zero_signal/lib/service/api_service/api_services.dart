import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:zero_signal/service/api_service/service_model/service_model.dart';
import '../../constant/api_end_point.dart';
import '../app_static_key.dart';
import '../local_database/prefs_helper.dart';
import '../storage/storage_service.dart';

class ApiService {
  static final Dio _dio = getMyDio();

  static late Response bodyData;

  static Future<ApiResponseModel> postApi(String url, body,
      {Map<String, String>? header}) async {
    return requestApi(url, "POST", body: body, header: header);
  }

  static Future<ApiResponseModel> getApi(
      String url, {
        Map<String, String>? header,
        Map<String, dynamic>? queryParams,
      }) async {
    return requestApi(url, "GET", header: header, queryParams: queryParams);
  }

  static Future<ApiResponseModel> putApi(String url,
      {Map<String, dynamic>? body, Map<String, String>? header}) async {
    return requestApi(url, "PUT", body: body, header: header);
  }

  static Future<ApiResponseModel> patchApi(String url,
      {body, Map<String, String>? header}) async {
    return requestApi(url, "PATCH", body: body, header: header);
  }

  static Future<ApiResponseModel> deleteApi(
      {required String url,
        required Map<String, dynamic> body,
        Map<String, String>? header}
      ) async {
    return requestApi(url, "DELETE", body: body, header: header);
  }

  /// POST Multipart request for file uploads
  static Future<ApiResponseModel> postMultipartApi(
      String url,
      dynamic body, {
        List<MultipartBody>? multipartBody,
        Map<String, String>? header,
        ProgressCallback? onSendProgress,
      }) async {
    try {
      Map<String, dynamic> formDataMap = {};

      // Convert body to form fields
      if (body is Map) {
        body.forEach((key, value) {
          if (value is List) {
            // Add each list item with array notation
            for (int i = 0; i < value.length; i++) {
              formDataMap['$key[$i]'] = value[i].toString();
            }
          } else if (value != null) {
            formDataMap[key.toString()] = value.toString();
          }
        });
      }

      final formData = FormData.fromMap(formDataMap);

      // Add files if provided
      if (multipartBody != null && multipartBody.isNotEmpty) {
        for (var element in multipartBody) {
          var mimeType = lookupMimeType(element.file.path) ?? 'application/octet-stream';

          if (kDebugMode) {
            debugPrint("File path: ${element.file.path}");
            debugPrint("MimeType: $mimeType");
          }

          var multipartFile = await MultipartFile.fromFile(
            element.file.path,
            filename: element.file.path.split('/').last,
            contentType: MediaType.parse(mimeType),
          );
          formData.files.add(MapEntry(element.key, multipartFile));
        }
      }

      final headers = header ?? {};
      headers["Content-Type"] = "multipart/form-data";

      Response response = await _dio.post(
        url,
        data: formData,
        options: Options(headers: headers),
        onSendProgress: onSendProgress,
      );

      return handleResponse(response);
    } catch (e) {
      return handleError(e);
    }
  }

  /// PATCH Multipart request for file uploads
  static Future<ApiResponseModel> patchMultipartApi(
      String url,
      Map<String, dynamic> body, {
        List<MultipartBody>? multipartBody,
        Map<String, String>? header,
        ProgressCallback? onSendProgress,
      }) async {
    try {
      // Create FormData without wrapping body in a single field
      final formData = FormData();

      // Add each field individually
      body.forEach((key, value) {
        formData.fields.add(MapEntry(key, value.toString()));
      });

      // Add files if provided
      if (multipartBody != null && multipartBody.isNotEmpty) {
        for (var element in multipartBody) {
          var mimeType = lookupMimeType(element.file.path) ?? 'application/octet-stream';

          if (kDebugMode) {
            debugPrint("File path: ${element.file.path}");
            debugPrint("MimeType: $mimeType");
          }

          var multipartFile = await MultipartFile.fromFile(
            element.file.path,
            filename: element.file.path.split('/').last,
            contentType: MediaType.parse(mimeType),
          );
          formData.files.add(MapEntry(element.key, multipartFile));
        }
      }

      // Log complete FormData details
      if (kDebugMode) {
        debugPrint("========== FormData Fields ==========");
        for (var entry in formData.fields) {
          debugPrint("${entry.key}: ${entry.value}");
        }

        debugPrint("========== FormData Files ==========");
        for (var entry in formData.files) {
          debugPrint("Key: ${entry.key}");
          debugPrint("  Filename: ${entry.value.filename}");
          debugPrint("  ContentType: ${entry.value.contentType}");
          debugPrint("  Length: ${entry.value.length}");
        }
        debugPrint("====================================");
      }

      final headers = header ?? {};
      headers["Content-Type"] = "multipart/form-data";

      Response response = await _dio.patch(
        url,
        data: formData,
        options: Options(headers: headers),
        onSendProgress: onSendProgress,
      );

      return handleResponse(response);
    } catch (e) {
      return handleError(e);
    }
  }

  static Future<ApiResponseModel> requestApi(
      String url,
      String method, {
        dynamic body,
        Map<String, String>? header,
        Map<String, dynamic>? queryParams,
      }) async {
    try {
      Response response = await _dio.request(
        url,
        data: body,
        options: Options(method: method, headers: header),
        queryParameters: queryParams,
      );

      return handleResponse(response);
    } catch (e) {
      return handleError(e);
    }
  }

  static ApiResponseModel handleResponse(Response response) {
    if (response.statusCode == 201) {
      return ApiResponseModel(
          200, response.data['message'] ?? "", response.data);
    }

    return ApiResponseModel(response.statusCode ?? 500,
        response.data['message'] ?? "", response.data);
  }

  static ApiResponseModel handleError(dynamic error) {
    if (error is DioException) {
      if (error.response != null) {
        if (error.response?.statusCode == 502) {
          return ApiResponseModel(502, "bad Gateway", {});
        }

        if (error.response?.statusCode == 401) {
          PrefsHelper.removeAllPrefData();
          return ApiResponseModel(401, error.response?.data?['message'], {});
        }
      }
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.sendTimeout:
          return ApiResponseModel(408, AppStaticKey.requestTimeOut, {});
        case DioExceptionType.connectionError:
          return ApiResponseModel(503, AppStaticKey.noInternetConnection, {});
        default:
          return ApiResponseModel(
              error.response?.statusCode ?? 500,
              error.response?.data?['message'] ??
                  error.message ??
                  "Unknown Error",
              {});
      }
    } else if (error is SocketException) {
      return ApiResponseModel(503, AppStaticKey.noInternetConnection, {});
    } else if (error is FormatException) {
      return ApiResponseModel(
          400, AppStaticKey.badResponseRequest, bodyData.data);
    } else if (error is TimeoutException) {
      return ApiResponseModel(408, AppStaticKey.requestTimeOut, {});
    } else {
      return ApiResponseModel(400, error.toString(), {});
    }
  }
}

Dio getMyDio() {
  Dio dio = Dio();
  Stopwatch stopwatch = Stopwatch();
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      options
        ..headers["Authorization"] ??= "Bearer ${LocalStorage.token}"
        ..headers["Content-Type"] ??= "application/json"
        ..sendTimeout = const Duration(seconds: 120)
        ..receiveTimeout = const Duration(seconds: 120)
        ..connectTimeout = const Duration(seconds: 120)
        ..baseUrl = options.baseUrl.startsWith("http")
            ? ""
            : AppApiEndPoint.instance.baseUrl
        ..extra["stopwatch"] = stopwatch;

      if (kDebugMode) {
        stopwatch.start();

        debugPrint(
            "Api Service==================>Requested URL:${options.method} ${options.uri}");
        debugPrint(
            "Api Service==================>Request Headers: ${options.headers}");

        if (options.headers["Content-Type"] == "application/json") {
          debugPrint(
              "Api Service==================>Request Body: ${jsonEncode(options.data)}");
        } else if (options.headers["Content-Type"] == "multipart/form-data") {
          if (options.data is FormData) {
            debugPrint(
                "Api Service==================>Request Body: multipart/form-data with ${(options.data as FormData).files.length} files");
            for (var entry in (options.data as FormData).files) {
              debugPrint(
                  "File Key: ${entry.key}, Filename: ${entry.value.filename}");
            }
          }
        }
      }
      handler.next(options);
    },
    onResponse: (response, handler) {
      if (kDebugMode) {
        stopwatch.stop();
        debugPrint(
            "Api Service==================>Response Time: ${stopwatch.elapsedMilliseconds / 1000} Second");
        debugPrint(
            "Api Service==================>Response Status Code: ${response.statusCode} ${response.requestOptions.uri}");
        debugPrint(
            "Api Service==================>Response Data: ${jsonEncode(response.data)}");
        stopwatch.reset();
      }
      handler.next(response);
    },
    onError: (error, handler) {
      if (kDebugMode) {
        stopwatch.stop();
        debugPrint(
            "Api Service==================>Response Time: ${stopwatch.elapsedMilliseconds / 1000} Second");
        debugPrint(
            "Api Service==================>Error Status Code: ${error.response?.statusCode} ${error.requestOptions.uri}");
        debugPrint(
            "Api Service==================>Error Data: ${jsonEncode(error.response?.data)}");
        stopwatch.reset();
      }
      handler.next(error);
    },
  ));
  return dio;
}

// Helper classes for multipart body
class MultipartBody {
  String key;
  File file;

  MultipartBody(this.key, this.file);
}

class MultipartListBody {
  String key;
  String value;

  MultipartListBody(this.key, this.value);
}

// Example usage:
/*
import 'dart:io';
import 'package:mime/mime.dart';

// POST with single file
Future<ApiResponseModel> uploadProfile(File imageFile) async {
  return await ApiService.postMultipartApi(
    '/user/profile',
    {
      'name': 'John Doe',
      'email': 'john@example.com',
    },
    multipartBody: [
      MultipartBody('profile_image', imageFile),
    ],
    onSendProgress: (sent, total) {
      print('Upload: ${(sent / total * 100).toStringAsFixed(0)}%');
    },
  );
}

// PATCH with multiple files
Future<ApiResponseModel> updateDegree(List<File> certificateFiles) async {
  List<MultipartBody> files = certificateFiles
      .map((file) => MultipartBody('certificates[]', file))
      .toList();

  return await ApiService.patchMultipartApi(
    '/user/profile/degree',
    {
      'degree_name': 'Bachelor of Science',
      'institution': 'University XYZ',
      'year': '2020',
    },
    multipartBody: files,
  );
}

// POST with array fields and files
Future<ApiResponseModel> uploadWithArrays(
    List<String> tags, List<File> images) async {
  Map<String, dynamic> body = {
    'title': 'My Upload',
  };

  // Array fields will be handled automatically
  for (int i = 0; i < tags.length; i++) {
    body['tags[$i]'] = tags[i];
  }

  List<MultipartBody> files =
      images.map((file) => MultipartBody('images[]', file)).toList();

  return await ApiService.postMultipartApi(
    '/upload',
    body,
    multipartBody: files,
  );
}
*/