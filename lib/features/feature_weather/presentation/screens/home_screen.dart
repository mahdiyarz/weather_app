import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:weather_app/core/params/forecast_params.dart';
import 'package:weather_app/core/utils/date_converter.dart';
import 'package:weather_app/core/widgets/app_background.dart';
import 'package:weather_app/core/widgets/dot_loading.dart';
import 'package:weather_app/features/feature_bookmark/presentation/bloc/bookmark_bloc.dart';
import 'package:weather_app/features/feature_weather/data/models/forecast_days_model.dart';
import 'package:weather_app/features/feature_weather/domain/entities/forecast_days_entity.dart';
import 'package:weather_app/features/feature_weather/domain/usecases/get_suggestion_city_usecase.dart';
import 'package:weather_app/features/feature_weather/presentation/bloc/fw_status.dart';
import 'package:weather_app/features/feature_weather/presentation/bloc/home_bloc.dart';
import 'package:weather_app/features/feature_weather/presentation/widgets/bookmark_icon.dart';
import 'package:weather_app/locator.dart';

import '../../domain/entities/current_city_entity.dart';
import '../bloc/cw_status.dart';
import '../widgets/day_weather_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String cityName = 'Tehran';
  final PageController _pageController = PageController();

  TextEditingController textEditingController = TextEditingController();
  GetSuggestionCityUseCase getSuggestionCityUseCase = GetSuggestionCityUseCase(
    locator(),
  );

  @override
  void initState() {
    super.initState();

    BlocProvider.of<HomeBloc>(context).add(LoadCwEvent(cityName));
  }

  @override
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;

    return SafeArea(
        child: Column(
      children: [
        SizedBox(
          height: deviceSize.height * .02,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: deviceSize.width * .03,
          ),
          child: Row(
            children: [
              Expanded(
                child: TypeAheadField(
                  controller: textEditingController,
                  builder: (context, controller, focusNode) {
                    return TextField(
                        controller: controller,
                        focusNode: focusNode,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter City Name...',
                          hintStyle: TextStyle(color: Colors.white),
                          labelStyle: TextStyle(color: Colors.white),
                        ));
                  },
                  itemBuilder: (context, value) {
                    return ListTile(
                      leading: const Icon(Icons.location_on),
                      title: Text(value.name!),
                      subtitle: Text('${value.region}, ${value.country}'),
                    );
                  },
                  onSelected: (value) {
                    textEditingController.text = value.name!;
                    BlocProvider.of<HomeBloc>(context)
                        .add(LoadCwEvent(value.name!));
                  },
                  suggestionsCallback: (search) {
                    return getSuggestionCityUseCase(search);
                  },
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              BlocBuilder<HomeBloc, HomeState>(
                buildWhen: (previous, current) {
                  if (previous.cwStatus == current.cwStatus) {
                    return false;
                  }
                  return true;
                },
                builder: (context, state) {
                  // show loading state for CW
                  if (state.cwStatus is CwLoading) {
                    return const CircularProgressIndicator();
                  }

                  // show Error state for CW
                  if (state.cwStatus is CwError) {
                    return IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.error,
                          color: Colors.white,
                          size: 35,
                        ));
                  }

                  if (state.cwStatus is CwCompleted) {
                    final CwCompleted cwCompleted =
                        state.cwStatus as CwCompleted;

                    BlocProvider.of<BookmarkBloc>(context).add(
                        GetCityByNameEvent(
                            cwCompleted.currentCityEntity.name!));

                    return BookmarkIcon(
                        cityName: cwCompleted.currentCityEntity.name!);
                  }

                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
        BlocBuilder<HomeBloc, HomeState>(
          buildWhen: (previous, current) {
            /// rebuild just when CwStatus changed
            if (previous.cwStatus == current.cwStatus) {
              return false;
            }
            return true;
          },
          builder: (context, state) {
            if (state.cwStatus is CwLoading) {
              return const Expanded(child: DotLoading());
            }
            if (state.cwStatus is CwError) {
              return const Center(
                child: Text('Error...'),
              );
            }
            if (state.cwStatus is CwCompleted) {
              /// cast
              final CwCompleted cwCompleted = state.cwStatus as CwCompleted;
              final CurrentCityEntity cityEntity =
                  cwCompleted.currentCityEntity;

              /// create params for api call
              final ForecastParams forecastParams = ForecastParams(
                lat: cityEntity.coord!.lat!,
                lon: cityEntity.coord!.lon!,
              );

              /// start load FW event
              BlocProvider.of<HomeBloc>(context)
                  .add(LoadFwEvent(forecastParams));

              /// change times to Hour --5:55 AM/PM--
              final sunrise = DateConverter.changeDtToDateTimeHour(
                  cityEntity.sys!.sunrise, cityEntity.timezone);

              final sunset = DateConverter.changeDtToDateTimeHour(
                  cityEntity.sys!.sunset, cityEntity.timezone);

              return Expanded(
                  child: ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: deviceSize.height * .02),
                    child: SizedBox(
                      width: deviceSize.width,
                      height: 430,
                      child: PageView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        allowImplicitScrolling: true,
                        controller: _pageController,
                        itemCount: 2,
                        itemBuilder: (context, position) {
                          if (position == 0) {
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 50),
                                  child: Text(
                                    cityEntity.name!,
                                    style: const TextStyle(
                                      fontSize: 30,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Text(
                                    cityEntity.weather![0].description!,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: AppBackground.setIconForMain(
                                      cityEntity.weather![0].icon!),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Text(
                                    '${cityEntity.main!.temp!.round()}\u00B0',
                                    style: const TextStyle(
                                      fontSize: 50,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        const Text(
                                          'max',
                                          style: TextStyle(
                                              fontSize: 16, color: Colors.grey),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          '${cityEntity.main!.tempMax!.round()}\u00B0',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    const VerticalDivider(
                                      color: Colors.white,
                                      thickness: 4,
                                    ),
                                    Column(
                                      children: [
                                        const Text(
                                          'min',
                                          style: TextStyle(
                                              fontSize: 16, color: Colors.grey),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          '${cityEntity.main!.tempMin!.round()}\u00B0',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: SmoothPageIndicator(
                        controller: _pageController,
                        count: 2,
                        effect: const ExpandingDotsEffect(
                          activeDotColor: Colors.white,
                        )),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    child: SizedBox(
                      height: 105,
                      width: deviceSize.width,
                      child: Center(
                        child: BlocBuilder<HomeBloc, HomeState>(
                          builder: (context, state) {
                            if (state.fwStatus is FwLoading) {
                              return const DotLoading();
                            }

                            if (state.fwStatus is FwError) {
                              final FwError fwError = state.fwStatus as FwError;
                              return Center(
                                child: Text(
                                  fwError.message,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              );
                            }

                            if (state.fwStatus is FwCompleted) {
                              final FwCompleted fwCompleted =
                                  state.fwStatus as FwCompleted;
                              final ForecastDaysEntity forecastDaysEntity =
                                  fwCompleted.forecastDaysEntity;
                              final List<Daily> mainDaily =
                                  forecastDaysEntity.daily!;

                              return ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: 8,
                                itemBuilder: (context, index) {
                                  return DaysWeatherView(
                                    daily: mainDaily[index],
                                  );
                                },
                              );
                            }

                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                    ),
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            'wind speed',
                            style: TextStyle(
                              fontSize: deviceSize.height * .017,
                              color: Colors.amber,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              '${cityEntity.wind!.speed} m/s',
                              style: TextStyle(
                                fontSize: deviceSize.height * .016,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          color: Colors.white,
                          width: 2,
                          height: 30,
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            'sunrise',
                            style: TextStyle(
                              fontSize: deviceSize.height * .017,
                              color: Colors.amber,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              sunrise,
                              style: TextStyle(
                                fontSize: deviceSize.height * .016,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          color: Colors.white,
                          width: 2,
                          height: 30,
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            'sunset',
                            style: TextStyle(
                              fontSize: deviceSize.height * .017,
                              color: Colors.amber,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              sunset,
                              style: TextStyle(
                                fontSize: deviceSize.height * .016,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          color: Colors.white,
                          width: 2,
                          height: 30,
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            'humidity',
                            style: TextStyle(
                              fontSize: deviceSize.height * .017,
                              color: Colors.amber,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              '${cityEntity.main!.humidity}%',
                              style: TextStyle(
                                fontSize: deviceSize.height * .016,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ));
            }

            return const Text(
              'no thing',
              style: TextStyle(color: Colors.white),
            );
          },
        ),
      ],
    ));
  }
}
