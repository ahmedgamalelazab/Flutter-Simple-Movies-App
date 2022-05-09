import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/bloc/movie_bloc/movie_bloc.dart';
import 'package:movies_app/bloc/wishList_bloc/wishlist_bloc.dart';
import 'package:movies_app/routes/applicationRoutes.dart';

import 'screens/HomeScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<MovieBloc>(
            create: (context) => MovieBloc()
              ..add(
                const GetMoviesByCategory(
                    category:
                        "popular"), // note this won't work unless one of the screen start to subscribe on it
              ),
          ),
          BlocProvider<WishlistBloc>(
            create: (context) =>
                WishlistBloc(), // it will be created with empty list inside of it
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          routes: ApplicationRoutesProvider.appRoutes(),
          initialRoute: ApplicationRoutesProvider.initialRoute(),
        ));
  }
}
