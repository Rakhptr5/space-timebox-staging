import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:timebox/constants/cores/api_constant.dart';

class ApiServices {
  ApiServices._();

  static final ApiServices _apiServices = ApiServices._();

  factory ApiServices() {
    return _apiServices;
  }

  static const int timeoutInMiliSeconds = 20000;

  static Dio dioCall({
    int timeout = timeoutInMiliSeconds,
    String? token,
    String? authorization,
    String? baseUrl,
  }) {
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (token != null) {
      headers['token'] = token;
    }

    if (authorization != null) {
      headers['Authorization'] = authorization;
    }

    var dio = Dio(
      BaseOptions(
        headers: headers,
        baseUrl: baseUrl ?? ApiConstant.apiBaseUrlStaging,
        connectTimeout: const Duration(seconds: 5000),
        contentType: "application/json",
        responseType: ResponseType.json,
      ),
    );

    dio.interceptors.add(_authInterceptor());

    return dio;
  }

  static Interceptor _authInterceptor() {
    return QueuedInterceptorsWrapper(
      onRequest: (reqOptions, handler) {
        log('${reqOptions.uri}', name: 'REQUEST URL');
        log('${reqOptions.headers}', name: 'HEADER');

        return handler.next(reqOptions);
      },
      onError: (error, handler) async {
        log(error.message ?? 'Error Message', name: 'ERROR MESSAGE');
        log('${error.response}', name: 'RESPONSE');

        return handler.next(error); //return non 401 error
      },
      onResponse: (response, handler) async {
        log('${response.data}', name: 'RESPONSE');
        log('${response.realUri}', name: 'RESPONSE URL');

        return handler.resolve(response);
      },
    );
  }
}
