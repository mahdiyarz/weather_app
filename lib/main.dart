import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/features/feature_bookmark/presentation/bloc/bookmark_bloc.dart';
import 'package:weather_app/features/feature_weather/presentation/bloc/home_bloc.dart';

import 'core/widgets/main_wrapper.dart';
import 'locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// init locator
  await setup();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) {
              return locator<HomeBloc>();
            },
          ),
          BlocProvider(
            create: (_) {
              return locator<BookmarkBloc>();
            },
          )
        ],
        child: MainWrapper(),
      ),
    );
  }
}
