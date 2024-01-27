import 'package:equatable/equatable.dart';
import 'package:weather_app/features/feature_bookmark/domain/entities/city_entity.dart';

abstract class GetCityStatus extends Equatable {}

class GetCityInitial extends GetCityStatus {
  @override
  List<Object?> get props => [];
}

class GetCityLoading extends GetCityStatus {
  @override
  List<Object?> get props => [];
}

class GetCityCompleted extends GetCityStatus {
  final CityEntity? cityInfo;

  GetCityCompleted(this.cityInfo);
  @override
  List<Object?> get props => [cityInfo];
}

class GetCityError extends GetCityStatus {
  final String? message;

  GetCityError(this.message);

  @override
  List<Object?> get props => [message];
}
