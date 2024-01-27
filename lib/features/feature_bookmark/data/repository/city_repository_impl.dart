import 'package:weather_app/core/resources/data_state.dart';
import 'package:weather_app/features/feature_bookmark/data/data_source/local/city_dao.dart';
import 'package:weather_app/features/feature_bookmark/domain/entities/city_entity.dart';
import 'package:weather_app/features/feature_bookmark/domain/repository/city_repository.dart';

class CityRepositoryImpl extends CityRepository {
  CityDao cityDao;
  CityRepositoryImpl(this.cityDao);

  /// call save city to DB and set status
  @override
  Future<DataState<String>> deleteCityByName(String cityName) async {
    try {
      await cityDao.deleteCityByName(cityName);
      return DataSuccess(cityName);
    } catch (e) {
      print(e.toString());
      return DataFailed('error: $e');
    }
  }

  @override
  Future<DataState<List<CityEntity>>> getAllCityFromDB() async {
    try {
      List<CityEntity> cities = await cityDao.getAllCity();
      return DataSuccess(cities);
    } catch (e) {
      print(e.toString());
      return DataFailed('error: $e');
    }
  }

  @override
  Future<DataState<CityEntity?>> getCityByName(String cityName) async {
    try {
      CityEntity? cityEntity = await cityDao.findCityByName(cityName);
      return DataSuccess(cityEntity);
    } catch (e) {
      print(e.toString());
      return DataFailed('error: $e');
    }
  }

  @override
  Future<DataState<CityEntity>> saveCityToDB(String cityName) async {
    try {
      // check city exist or not
      CityEntity? checkCity = await cityDao.findCityByName(cityName);
      if (checkCity != null) {
        return DataFailed('$cityName has already exist');
      }

      // insert city to DB
      CityEntity cityInfo = CityEntity(cityName);
      await cityDao.insertCity(cityInfo);
      return DataSuccess(cityInfo);
    } catch (e) {
      print(e.toString());
      return DataFailed('error: $e');
    }
  }
}
