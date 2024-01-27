import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_app/core/resources/data_state.dart';
import 'package:weather_app/core/usecase/use_case.dart';
import 'package:weather_app/features/feature_bookmark/domain/use_cases/delete_city_usecase.dart';
import 'package:weather_app/features/feature_bookmark/domain/use_cases/get_all_city_usecase.dart';
import 'package:weather_app/features/feature_bookmark/domain/use_cases/get_city_usecase.dart';
import 'package:weather_app/features/feature_bookmark/domain/use_cases/save_city_usecase.dart';
import 'package:weather_app/features/feature_bookmark/presentation/bloc/delete_city_status.dart';
import 'package:weather_app/features/feature_bookmark/presentation/bloc/get_all_city_status.dart';
import 'package:weather_app/features/feature_bookmark/presentation/bloc/get_city_status.dart';
import 'package:weather_app/features/feature_bookmark/presentation/bloc/save_city_status.dart';

part 'bookmark_event.dart';
part 'bookmark_state.dart';

class BookmarkBloc extends Bloc<BookmarkEvent, BookmarkState> {
  GetCityUseCase getCityUseCase;
  SaveCityUseCase saveCityUseCase;
  GetAllCityUseCase getAllCityUseCase;
  DeleteCityUseCase deleteCityUseCase;

  BookmarkBloc(
    this.getCityUseCase,
    this.saveCityUseCase,
    this.getAllCityUseCase,
    this.deleteCityUseCase,
  ) : super(
          BookmarkState(
            getCityStatus: GetCityLoading(),
            saveCityStatus: SaveCityInitial(),
            deleteCityStatus: DeleteCityInitial(),
            getAllCityStatus: GetAllCityLoading(),
          ),
        ) {
    /// get all cities
    on<GetAllCityEvent>(
      (event, emit) async {
        // emit loading state
        emit(state.copyWith(newGetAllCityStatus: GetAllCityLoading()));

        DataState dataState = await getAllCityUseCase(NoParams());

        // emit complete state
        if (dataState is DataSuccess) {
          emit(state.copyWith(
              newGetAllCityStatus: GetAllCityCompleted(dataState.data)));
        }

        // emit error state
        if (dataState is DataFailed) {
          emit(state.copyWith(
              newGetAllCityStatus: GetAllCityError(dataState.error)));
        }
      },
    );

    /// get city by name event
    on<GetCityByNameEvent>((event, emit) async {
      // emit loading state
      emit(state.copyWith(newGetCityStatus: GetCityLoading()));

      DataState dataState = await getCityUseCase(event.cityName);

      // emit complete state
      if (dataState is DataSuccess) {
        emit(
            state.copyWith(newGetCityStatus: GetCityCompleted(dataState.data)));
      }

      // emit error state
      if (dataState is DataFailed) {
        emit(state.copyWith(newGetCityStatus: GetCityError(dataState.error)));
      }
    });

    /// save city event
    on<SaveCityEvent>((event, emit) async {
      // emit loading state
      emit(state.copyWith(newSaveCityStatus: SaveCityLoading()));

      DataState dataState = await saveCityUseCase(event.cityName);

      // emit complete state
      if (dataState is DataSuccess) {
        emit(state.copyWith(
            newSaveCityStatus: SaveCityCompleted(dataState.data)));
      }

      // emit error state
      if (dataState is DataFailed) {
        emit(state.copyWith(newSaveCityStatus: SaveCityError(dataState.error)));
      }
    });

    /// set to init again save city
    /// because if we don't have this event, after save a city, the bookmark
    /// icon wouldn't be back to the normal style with new city name
    on<SaveCityInitialEvent>((event, emit) async {
      emit(state.copyWith(newSaveCityStatus: SaveCityInitial()));
    });

    /// delete city event
    on<DeleteCityEvent>(
      (event, emit) async {
        // emit loading state
        emit(state.copyWith(newDeleteCityStatus: DeleteCityLoading()));

        DataState dataState = await deleteCityUseCase(event.cityName);

        // emit complete state
        if (dataState is DataSuccess) {
          emit(state.copyWith(
              newDeleteCityStatus: DeleteCityCompleted(dataState.data)));
        }

        // emit error state
        if (dataState is DataFailed) {
          emit(state.copyWith(
              newDeleteCityStatus: DeleteCityError(dataState.error)));
        }
      },
    );
  }
}
