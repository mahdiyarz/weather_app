part of 'bookmark_bloc.dart';

sealed class BookmarkEvent {}

class GetAllCityEvent extends BookmarkEvent {}

class GetCityByNameEvent extends BookmarkEvent {
  final String cityName;

  GetCityByNameEvent(this.cityName);
}

class SaveCityEvent extends BookmarkEvent {
  final String cityName;

  SaveCityEvent(this.cityName);
}

class SaveCityInitialEvent extends BookmarkEvent {}

class DeleteCityEvent extends BookmarkEvent {
  final String cityName;

  DeleteCityEvent(this.cityName);
}
