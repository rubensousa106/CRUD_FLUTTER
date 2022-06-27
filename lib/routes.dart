import 'package:flutter/widgets.dart';
import 'package:projecto_final/screens/details/details_screen.dart';
import 'package:projecto_final/screens/ecra/ecra_screen.dart';
import 'package:projecto_final/screens/home/home_screen.dart';
import 'package:projecto_final/screens/splash/splash_screen.dart';

final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  EcraScreen.routeName: (context) => EcraScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  DetailsScreen.routeName: (context) => DetailsScreen(),
};
