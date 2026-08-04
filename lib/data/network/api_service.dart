import 'dart:io';
import 'package:dio/dio.dart';
// dio and get both export Response/FormData/MultipartFile — this file is a dio
// wrapper, so get's versions are hidden.
import 'package:get/get.dart' hide FormData, MultipartFile, Response;
import '../local/shared_prefs.dart';
import '../../routes/app_routes.dart';
import 'api_endpoints.dart';
import 'network_wrapper.dart';

/// Endpoints that legitimately answer 401 while the user is signed out — a
/// wrong password must surface on the login form, not bounce off it.
const List<String> _authEndpoints = [
  ApiEndPoint.login,
  ApiEndPoint.signUp,
  ApiEndPoint.verifyOtp,
  ApiEndPoint.resetPassword,
  ApiEndPoint.forgetPass,
  ApiEndPoint.register,
];

/// Set while the app is on its way to the login screen, so that a burst of
/// parallel 401s (the home screen fires several calls at once) triggers a
/// single redirect instead of one per response.
bool _redirectingToLogin = false;

bool _isAuthEndpoint(String path) =>
    _authEndpoints.any((e) => path.startsWith(e.split('?').first));

/// Drops the session and sends the user to the login screen. Called for any
/// 401 outside the auth endpoints: an empty or rejected token both mean the
/// app cannot show signed-in content.
Future<void> _handleUnauthenticated(String path) async {
  if (_redirectingToLogin) return;
  if (_isAuthEndpoint(path)) return;
  if (Get.currentRoute == AppRoutes.loginScreen) return;

  _redirectingToLogin = true;
  await SharedPref.clearPref();
  Get.offAllNamed(AppRoutes.loginScreen);
  _redirectingToLogin = false;
}

/// User-facing message shown when a request never reaches the server (no
/// internet, DNS lookup failure, or a timeout) — i.e. a [DioException] with no
/// response. Distinct from "something went wrong" so the UI can offer a retry.
const String kConnectionErrorMessage =
    "Can't reach the server. Please check your internet connection and try again.";

/// True when [e] is a connectivity failure rather than a real server response
/// (bad status). Covers DNS/host-lookup failures, dropped connections and
/// timeouts.
bool isConnectionError(DioException e) {
  return e.type == DioExceptionType.connectionError ||
      e.type == DioExceptionType.connectionTimeout ||
      e.type == DioExceptionType.receiveTimeout ||
      e.type == DioExceptionType.sendTimeout ||
      e.error is SocketException;
}

/// Message to surface for a [DioException] that carried no response: a friendly
/// connectivity message for connection errors, else the generic fallback.
String _noResponseMessage(DioException error) =>
    isConnectionError(error) ? kConnectionErrorMessage : "something went wrong";

class ApiService {
  Dio? _dio;

  ApiService() {

    BaseOptions options = BaseOptions(
        baseUrl: ApiEndPoint.baseUrl
    );

    _dio = Dio(options);
    _dio?.interceptors
        .add(LogInterceptor(responseBody: true, requestBody: true));

    _dio?.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        return handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        if (e.response?.statusCode == 401) {
          _handleUnauthenticated(e.requestOptions.path);
        }
        return handler.next(e);
      },
    ));
  }

  Future<NetworkWrapper<Map<String,dynamic>>> getRequest(String endpoint, {Map<String, dynamic>? data,String defaultToken =""
    ,bool isBearer =false}) async {
    try {
      var token =  await SharedPref.getAccessToken()??"";
      print(endpoint);
      Map<String, dynamic> defaultHeaders = {
        'Authorization':  isBearer? "Bearer "+token:token ,
        'Accept':"application/json",
        'Content-Type': 'application/json',
      };
      Response response = await _dio!.get(
          endpoint,
          data: data,
          options: Options(headers:defaultHeaders )
      );
      return NetworkWrapper(data: response.data);
    }
    on DioException catch (error) {
      if(error.response !=null){
        if (error.response!.statusCode == 403) {

          var message = error.response!.data as Map<String,dynamic>;
          var errorMessage = message['message']?? message['error']??"something went wrong";

          return NetworkWrapper(error: errorMessage);

        }
        if (error.response!.statusCode == 401) {

          var message = error.response!.data as Map<String,dynamic>;
          var errorMessage = message['message']??"something went wrong";

          return NetworkWrapper(error: errorMessage);

        }
        else if (error.response!.statusCode == 500) {
          var message = error.response!.data as Map<String,dynamic>;
          var errorMessage = message['message']??"something went wrong";

          return NetworkWrapper(error: errorMessage);
        }
        else {

          var message = error.response!.data as Map<String,dynamic>;
          var errorMessage = message['message']??"something went wrong";
          // throw Exception('Network Error: ${error.message}');
          return NetworkWrapper(error: errorMessage);


        }
      }else{
        return NetworkWrapper(error: _noResponseMessage(error));
      }
    }

  }

  Future<NetworkWrapper<Map<String,dynamic>>> postRequest(String endpoint, dynamic data,{bool isBearer= false}) async {
    try {
      var token =  await SharedPref.getAccessToken()??"";
      Map<String, dynamic> defaultHeaders = {
        'Authorization': isBearer? "Bearer "+token:token ,
        'Accept':"application/json",
        'Content-Type': 'application/json',
      };
      Response response = await _dio!.post(
          endpoint,
          data: data,
          options: Options(headers: defaultHeaders,validateStatus: (statusCode){
            if(statusCode == null){
              return false;
            }
            if(statusCode == 422){ // your http status code
              return false;
            }else{
              // return statusCode >= 200 && statusCode < 300;
              return statusCode ==200;
            }
          },)
      );
      return NetworkWrapper(data: response.data);
    }on DioException catch (error) {
      error;
      if(error.response !=null){
        if (error.response!.statusCode == 403) {

          var message = error.response!.data as Map<String,dynamic>;
          var errorMessage = message['message']?? message['error']??"something went wrong";

          return NetworkWrapper(error: errorMessage);

        }
        if (error.response!.statusCode == 401) {
          // var message = error.response!.data as String;
          // var errorMessage = message??"something went wrong";

          var message = error.response!.data as Map<String,dynamic>;
          var errorMessage = message['message']??"something went wrong";

          return NetworkWrapper(error: errorMessage);

        }
        if (error.response!.statusCode == 422) {
          // var message = error.response!.data as String;
          // var errorMessage = message??"something went wrong";

          var message = error.response!.data as Map<String,dynamic>;
          var errorMessage = message['message']??"something went wrong";

          return NetworkWrapper(error: errorMessage);

        }
        else if (error.response!.statusCode == 500) {
          var errorMessage = " 500: Internal server error ";

          return NetworkWrapper(error: errorMessage);
        }
        else if (error.response!.statusCode == 302) {
          return NetworkWrapper(error: "302: server error");
          var message = error.response!.data as Map<String,dynamic>;
          var errorMessage = message['message']??"something went wrong";

          // return NetworkWrapper(error: errorMessage);
        }
        else {

          var message = error.response!.data as Map<String,dynamic>;
          var errorMessage = message['message']??"something went wrong";
          // throw Exception('Network Error: ${error.message}');
          return NetworkWrapper(error: errorMessage);


        }
      }else{
        return NetworkWrapper(error: _noResponseMessage(error));
      }

    }
  }


  Future<NetworkWrapper<Map<String,dynamic>>> postRequestEmpty(String endpoint,{bool isBearer= false}) async {
    try {
      var token =  await SharedPref.getAccessToken()??"";
      Map<String, dynamic> defaultHeaders = {
        'Authorization':  isBearer? "Bearer "+token:token ,
        'Accept':"application/json",
        'Content-Type': 'application/json',
      };
      Response response = await _dio!.post(
          endpoint,

          options: Options(headers: defaultHeaders,validateStatus: (statusCode){
            if(statusCode == null){
              return false;
            }
            if(statusCode == 422){ // your http status code
              return false;
            }else{
              // return statusCode >= 200 && statusCode < 300;
              return statusCode ==200;
            }
          },)
      );
      return NetworkWrapper(data: response.data);
    }on DioException catch (error) {
      error;
      if(error.response !=null){
        if (error.response!.statusCode == 403) {

          var message = error.response!.data as Map<String,dynamic>;
          var errorMessage = message['message']?? message['error']??"something went wrong";

          return NetworkWrapper(error: errorMessage);

        }
        if (error.response!.statusCode == 401) {
          // var message = error.response!.data as String;
          // var errorMessage = message??"something went wrong";

          var message = error.response!.data as Map<String,dynamic>;
          var errorMessage = message['message']??"something went wrong";

          return NetworkWrapper(error: errorMessage);

        }
        if (error.response!.statusCode == 422) {
          // var message = error.response!.data as String;
          // var errorMessage = message??"something went wrong";

          var message = error.response!.data as Map<String,dynamic>;
          var errorMessage = message['message']??"something went wrong";

          return NetworkWrapper(error: errorMessage);

        }
        else if (error.response!.statusCode == 500) {
          var errorMessage = " 500: Internal server error ";

          return NetworkWrapper(error: errorMessage);
        }
        else if (error.response!.statusCode == 302) {
          return NetworkWrapper(error: "302: server error");
          var message = error.response!.data as Map<String,dynamic>;
          var errorMessage = message['message']??"something went wrong";

          // return NetworkWrapper(error: errorMessage);
        }
        else {

          var message = error.response!.data as Map<String,dynamic>;
          var errorMessage = message['message']??"something went wrong";
          // throw Exception('Network Error: ${error.message}');
          return NetworkWrapper(error: errorMessage);


        }
      }else{
        return NetworkWrapper(error: _noResponseMessage(error));
      }

    }
  }

  Future<Response> uploadFile(String endpoint, String value, File file) async {
    try {


      String fileName = file.path.split('/').last;
      FormData data = FormData.fromMap({
        value: await MultipartFile.fromFile(
          file.path,
          filename: fileName,
        ),
      });
      Response response = await _dio!.post(
        endpoint,
        data: data,

      );
      return response;
    } on DioException catch (error) {
      if (error.response!.statusCode == 403) {
        throw Exception('Forbidden: ${error.message}');
      } else if (error.response!.statusCode == 500) {
        throw Exception('Internal Server Error: ${error.message}');
      } else {
        throw Exception('Network Error: ${error.message}');
      }
    }
  }
}

class ApiService2{
  Dio? _dio;
  ApiService2() {

    BaseOptions options = BaseOptions(
        baseUrl: ApiEndPoint.baseUrl2
    );

    _dio = Dio(options);
    _dio?.interceptors
        .add(LogInterceptor(responseBody: true, requestBody: true));

    _dio?.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        return handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        e;
        return handler.next(e);
      },
    ));
  }

Future<Response> uploadFile(String endpoint, String value, File file) async {
  try {


    String fileName = file.path.split('/').last;
    FormData data = FormData.fromMap({
      value: await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      ),
    });
    Response response = await _dio!.post(
      endpoint,
      data: data,

    );
    return response;
  } on DioException catch (error) {
    if (error.response!.statusCode == 403) {
      throw Exception('Forbidden: ${error.message}');
    } else if (error.response!.statusCode == 500) {
      throw Exception('Internal Server Error: ${error.message}');
    } else {
      throw Exception('Network Error: ${error.message}');
    }
  }
}

}



