import 'package:flutter/material.dart';
import 'package:ui_flutter_app/app/app_exceptions.dart';
import 'package:ui_flutter_app/pages/basket/basket.dart';
import 'package:ui_flutter_app/pages/login/login.dart';
import 'package:ui_flutter_app/pages/transaction_completed/transaction_completed.dart';
import 'package:ui_flutter_app/pages/welcome/welcome.dart';

// coverage:ignore-file
class AppRouting {
  AppRouting._();

  static const String basket = '/basket';
  static const String checkout = '/checkout';
  static const String login = '/login';
  static const String welcome = '/welcome';
  static const String transactionCompleted = '/transaction-completed';

  static Map<String, WidgetBuilder> define() {
    return {
      basket: (context) => const BasketPage(),
      login: (context) => const LoginPage(),
      welcome: (context) => const WelcomePage(),
      transactionCompleted: (context) => const TransactionCompletedPage(),
    };
  }

  static Route<dynamic> onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case basket:
        return MaterialPageRoute(builder: (_) => const BasketPage());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case welcome:
        return MaterialPageRoute(builder: (_) => const WelcomePage());
      case transactionCompleted:
        return MaterialPageRoute(
            builder: (_) => const TransactionCompletedPage());
      default:
        throw const NoRouteException('Invalid Route Specified');
    }
  }
}
