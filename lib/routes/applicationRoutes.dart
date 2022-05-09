import 'package:flutter/material.dart';
import 'package:movies_app/screens/HomeScreen.dart';
import 'package:movies_app/screens/movieDetailPage.dart';
import 'package:movies_app/screens/wishListScreen.dart';

class ApplicationRoutesProvider {
  static Map<String, Widget Function(BuildContext)> appRoutes() {
    return {
      HomeScreen.PAGE_ROUTE: (context) => HomeScreen(),
      WishListScreen.SCREEN_ROUTE: (context) => WishListScreen(),
      MovieDetailScreen.SCREEN_ROUTE: (context) => MovieDetailScreen()
    };
  }

  static String initialRoute() {
    return HomeScreen.PAGE_ROUTE;
  }
}
