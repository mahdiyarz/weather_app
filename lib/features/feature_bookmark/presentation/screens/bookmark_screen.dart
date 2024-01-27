import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/features/feature_bookmark/domain/entities/city_entity.dart';
import 'package:weather_app/features/feature_bookmark/presentation/bloc/bookmark_bloc.dart';
import 'package:weather_app/features/feature_bookmark/presentation/bloc/get_all_city_status.dart';
import 'package:weather_app/features/feature_weather/presentation/bloc/home_bloc.dart';

import '../../../../core/widgets/dot_loading.dart';

class BookmarkScreen extends StatelessWidget {
  final PageController pageController;
  const BookmarkScreen({
    required this.pageController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<BookmarkBloc>(context).add(GetAllCityEvent());

    return BlocBuilder<BookmarkBloc, BookmarkState>(
      /// rebuild UI just when `AllCityStatus` changed
      buildWhen: (previous, current) {
        if (previous.getAllCityStatus == current.getAllCityStatus) {
          return false;
        }
        return true;
      },
      builder: (context, state) {
        /// show loading for `AllCityStatus`
        if (state.getAllCityStatus is GetAllCityLoading) {
          return const DotLoading();
        }

        /// show error for `AllCityStatus`
        if (state.getAllCityStatus is GetAllCityError) {
          /// casting for getting error
          GetAllCityError getAllCityError =
              state.getCityStatus as GetAllCityError;

          return Center(
            child: Text(getAllCityError.message!),
          );
        }

        /// show complete for `AllCityStatus`
        if (state.getAllCityStatus is GetAllCityCompleted) {
          /// casting for getting error
          GetAllCityCompleted getAllCityCompleted =
              state.getAllCityStatus as GetAllCityCompleted;
          List<CityEntity> cities = getAllCityCompleted.citiesInfo;

          return SafeArea(
              child: Column(
            children: [
              const Text(
                'WatchList',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 25,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(

                  /// show text in center if there is no city bookmark
                  child: cities.isEmpty
                      ? const Center(
                          child: Text(
                            'There is no bookmark city',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : ListView.builder(
                          itemCount: cities.length,
                          itemBuilder: (context, index) {
                            CityEntity city = cities[index];

                            return GestureDetector(
                              onTap: () {
                                /// call for getting bookmark city date
                                BlocProvider.of<HomeBloc>(context)
                                    .add(LoadCwEvent(city.name));

                                /// animate to [HomeScreen] for showing data
                                pageController.animateToPage(0,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRect(
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 5.0, sigmaY: 5.0),
                                    child: Container(
                                      width: MediaQuery.sizeOf(context).width,
                                      height: 60.0,
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20)),
                                          color: Colors.grey.withOpacity(0.1)),
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 20.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              city.name,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            ),
                                            IconButton(
                                                onPressed: () {
                                                  BlocProvider.of<BookmarkBloc>(
                                                          context)
                                                      .add(DeleteCityEvent(
                                                          city.name));
                                                  BlocProvider.of<BookmarkBloc>(
                                                          context)
                                                      .add(GetAllCityEvent());
                                                },
                                                icon: const Icon(
                                                  Icons.delete,
                                                  color: Colors.redAccent,
                                                )),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        )),
            ],
          ));
        }

        /// show default value
        return const SizedBox.shrink();
      },
    );
  }
}
