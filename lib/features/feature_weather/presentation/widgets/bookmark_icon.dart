import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/features/feature_bookmark/domain/entities/city_entity.dart';
import 'package:weather_app/features/feature_bookmark/presentation/bloc/bookmark_bloc.dart';
import 'package:weather_app/features/feature_bookmark/presentation/bloc/get_city_status.dart';
import 'package:weather_app/features/feature_bookmark/presentation/bloc/save_city_status.dart';

class BookmarkIcon extends StatelessWidget {
  final String cityName;
  const BookmarkIcon({required this.cityName, super.key});

  @override
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;

    return BlocBuilder<BookmarkBloc, BookmarkState>(
      buildWhen: (previous, current) {
        /// if state don't change => don't rebuild UI
        if (previous.getCityStatus == current.getCityStatus) {
          return false;
        }
        return true;
      },
      builder: (context, state) {
        /// initial save bloc
        BlocProvider.of<BookmarkBloc>(context).add(SaveCityInitialEvent());

        /// show loading for `CityStatus`
        if (state.getCityStatus is GetCityLoading) {
          return const CircularProgressIndicator();
        }

        /// show completed for `CityStatus`
        if (state.getCityStatus is GetCityCompleted) {
          /// casting for getting city
          GetCityCompleted getCityCompleted =
              state.getCityStatus as GetCityCompleted;
          CityEntity? cityInfo = getCityCompleted.cityInfo;

          return BlocConsumer<BookmarkBloc, BookmarkState>(
            listenWhen: (previous, current) {
              /// if state don't change => don't listen to changes
              if (current.saveCityStatus == previous.saveCityStatus) {
                return false;
              }
              return true;
            },
            buildWhen: (previous, current) {
              /// if state don't change => don't rebuild UI
              if (current.saveCityStatus == previous.saveCityStatus) {
                return false;
              }
              return true;
            },
            listener: (context, cityState) {
              /// show error as snackbar
              if (cityState.saveCityStatus is SaveCityError) {
                // cast for getting error
                SaveCityError saveCityError =
                    cityState.saveCityStatus as SaveCityError;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(saveCityError.message!),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }

              /// show success snackbar
              if (cityState.saveCityStatus is SaveCityCompleted) {
                // cast for getting data
                SaveCityCompleted saveCityCompleted =
                    cityState.saveCityStatus as SaveCityCompleted;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        '${saveCityCompleted.cityInfo.name} added to bookmark'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            builder: (context, cityState) {
              /// show UI for initial `saveCity`
              if (cityState.saveCityStatus is SaveCityInitial) {
                return IconButton(
                    onPressed: () {
                      /// call event for save current city in database
                      BlocProvider.of<BookmarkBloc>(context)
                          .add(SaveCityEvent(cityName));
                    },
                    icon: Icon(
                      cityInfo == null ? Icons.star_border : Icons.star,
                      color: Colors.white,
                      size: 35,
                    ));
              }

              /// show UI for loading `saveCity`
              if (cityState.saveCityStatus is SaveCityLoading) {
                return const CircularProgressIndicator();
              }

              /// show UI for completed or error `saveCity`
              return IconButton(
                  onPressed: () {
                    /// call event for save current city in database
                    BlocProvider.of<BookmarkBloc>(context)
                        .add(SaveCityEvent(cityName));
                  },
                  icon: const Icon(
                    Icons.star,
                    color: Colors.white,
                    size: 35,
                  ));
            },
          );
        }

        /// show error for `CityStatus`
        if (state.getCityStatus is GetCityError) {
          return IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.error,
                color: Colors.white,
                size: 35,
              ));
        }

        /// default value
        return const SizedBox.shrink();
      },
    );
  }
}
