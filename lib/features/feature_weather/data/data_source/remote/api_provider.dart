import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/core/utils/constants.dart';

import '../../../../../core/params/forecast_params.dart';

class ApiProvider {
  final Dio _dio = Dio();

  //* current weather api call
  Future<dynamic> callCurrentWeather(String cityName) async {
    var response = await _dio.get('${Constants.baseUrl}/data/2.5/weather',
        queryParameters: {
          'q': cityName,
          'appid': Constants.apiKeys,
          'units': 'metric'
        });
    debugPrint(response.statusCode.toString());
    debugPrint(response.data.toString());
    return response;
  }

  //* 7 days forecast api
  Future<dynamic> sendRequest7DaysForecast(ForecastParams params) async {
    var response = await _dio
        .get('${Constants.baseUrl}/data/2.5/onecall', queryParameters: {
      'lat': params.lat,
      'lon': params.lon,
      'exclude': 'minutely,hourly',
      'appid': Constants.apiKeys,
      'units': 'metric'
    });
    debugPrint(response.statusCode.toString());
    debugPrint(response.data.toString());
    return response;
  }

  //* city name suggestion api
  Future<dynamic> sendRequestCitySuggestion(String prefix) async {
    var response = await _dio.get(
        'http://geodb-free-service.wirefreethought.com/v1/geo/cities',
        queryParameters: {
          'limit': 5,
          'offset': 2,
          'namePrefix': prefix,
        });
    debugPrint(response.statusCode.toString());
    debugPrint(response.data.toString());
    return response;
  }
}
