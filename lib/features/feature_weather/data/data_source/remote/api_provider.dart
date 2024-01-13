import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/core/utils/constants.dart';

class ApiProvider {
  final Dio _dio = Dio();

  //* current weather api call
  Future<dynamic> callCurrentWeather(String cityName) async {
    var response = await _dio
        .get('${Constants.baseUrl}/data/2.5/weather', queryParameters: {
      'q': cityName,
      'appid': Constants.apiKeys,
    });
    debugPrint(response.statusCode.toString());
    debugPrint(response.data.toString());
    return response;
  }
}
