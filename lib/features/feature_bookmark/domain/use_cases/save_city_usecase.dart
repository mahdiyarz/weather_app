import 'package:weather_app/core/resources/data_state.dart';
import 'package:weather_app/core/usecase/use_case.dart';
import 'package:weather_app/features/feature_bookmark/domain/entities/city_entity.dart';
import 'package:weather_app/features/feature_bookmark/domain/repository/city_repository.dart';

class SaveCityUseCase implements UseCase<DataState<CityEntity>, String> {
  final CityRepository _cityRepository;

  SaveCityUseCase(this._cityRepository);

  @override
  Future<DataState<CityEntity>> call(String params) {
    return _cityRepository.saveCityToDB(params);
  }
}
