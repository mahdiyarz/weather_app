part of 'bookmark_bloc.dart';

class BookmarkState extends Equatable {
  final GetCityStatus getCityStatus;
  final SaveCityStatus saveCityStatus;
  final DeleteCityStatus deleteCityStatus;
  final GetAllCityStatus getAllCityStatus;
  const BookmarkState({
    required this.getCityStatus,
    required this.saveCityStatus,
    required this.deleteCityStatus,
    required this.getAllCityStatus,
  });

  @override
  List<Object> get props => [
        getCityStatus,
        saveCityStatus,
        deleteCityStatus,
        getAllCityStatus,
      ];

  BookmarkState copyWith({
    GetCityStatus? newGetCityStatus,
    SaveCityStatus? newSaveCityStatus,
    DeleteCityStatus? newDeleteCityStatus,
    GetAllCityStatus? newGetAllCityStatus,
  }) {
    return BookmarkState(
      getCityStatus: newGetCityStatus ?? getCityStatus,
      saveCityStatus: newSaveCityStatus ?? saveCityStatus,
      deleteCityStatus: newDeleteCityStatus ?? deleteCityStatus,
      getAllCityStatus: newGetAllCityStatus ?? getAllCityStatus,
    );
  }
}
