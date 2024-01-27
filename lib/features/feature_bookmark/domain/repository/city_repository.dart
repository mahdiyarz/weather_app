import 'package:weather_app/core/resources/data_state.dart';
import 'package:weather_app/features/feature_bookmark/domain/entities/city_entity.dart';

abstract class CityRepository {
  Future<DataState<CityEntity>> saveCityToDB(String cityName);
  Future<DataState<List<CityEntity>>> getAllCityFromDB();
  Future<DataState<CityEntity?>> getCityByName(String cityName);
  Future<DataState<String>> deleteCityByName(String cityName);
}
