import 'package:equatable/equatable.dart';
import 'package:weather_app/features/feature_bookmark/domain/entities/city_entity.dart';

abstract class GetAllCityStatus extends Equatable {}

class GetAllCityInitial extends GetAllCityStatus {
  @override
  List<Object?> get props => [];
}

class GetAllCityLoading extends GetAllCityStatus {
  @override
  List<Object?> get props => [];
}

class GetAllCityCompleted extends GetAllCityStatus {
  final List<CityEntity> citiesInfo;

  GetAllCityCompleted(this.citiesInfo);
  @override
  List<Object?> get props => [citiesInfo];
}

class GetAllCityError extends GetAllCityStatus {
  final String? message;

  GetAllCityError(this.message);

  @override
  List<Object?> get props => [message];
}
