import 'package:flutter/widgets.dart';
import 'package:projecto_final/screens/details/details_screen.dart';
import 'package:projecto_final/screens/home/home_screen.dart';
import 'package:projecto_final/screens/splash/splash_screen.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  DetailsScreen.routeName: (context) => DetailsScreen(),
};
