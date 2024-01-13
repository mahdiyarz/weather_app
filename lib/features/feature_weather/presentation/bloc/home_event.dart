part of 'home_bloc.dart';

@immutable
sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

@immutable
class LoadCwEvent extends HomeEvent {
  final String cityName;

  const LoadCwEvent(this.cityName);
}
