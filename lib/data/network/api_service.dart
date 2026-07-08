import 'dart:io';
import 'package:dio/dio.dart';
import '../local/shared_prefs.dart';
import 'api_endpoints.dart';
import 'network_wrapper.dart';


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
        e;
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
        return NetworkWrapper(error: "something went wrong");
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
        return NetworkWrapper(error: "something went wrong");
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
        return NetworkWrapper(error: "something went wrong");
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



