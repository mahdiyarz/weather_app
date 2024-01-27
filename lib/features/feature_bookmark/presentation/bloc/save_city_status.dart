import 'package:equatable/equatable.dart';
import 'package:weather_app/features/feature_bookmark/domain/entities/city_entity.dart';

abstract class SaveCityStatus extends Equatable {}

class SaveCityInitial extends SaveCityStatus {
  @override
  List<Object?> get props => [];
}

class SaveCityLoading extends SaveCityStatus {
  @override
  List<Object?> get props => [];
}

class SaveCityCompleted extends SaveCityStatus {
  final CityEntity cityInfo;

  SaveCityCompleted(this.cityInfo);
  @override
  List<Object?> get props => [cityInfo];
}

class SaveCityError extends SaveCityStatus {
  final String? message;

  SaveCityError(this.message);

  @override
  List<Object?> get props => [message];
}
