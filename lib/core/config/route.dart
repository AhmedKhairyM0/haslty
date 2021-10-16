import 'package:expense_tracker/data/dataSource/sharedPref/shared_cache.dart';
import 'package:expense_tracker/view/screens/addition_screen.dart';
import 'package:expense_tracker/view/screens/gathering_balance_screen.dart';
import 'package:expense_tracker/view/screens/home_screen.dart';
import 'package:expense_tracker/view/widgets/error_state_widget.dart';

import 'package:flutter/material.dart';

class RouteGenerator {
  static const homeScreen = '/';
  static const additionScreen = '/addition';
  static const getheringBalanceScreen = '/gatherBalance';
  // static const infoBalanceScreen = '/gatherBalance';

  static Route onGenerate(RouteSettings settings) {
    switch (settings.name) {
      case homeScreen:
        return MaterialPageRoute(builder: (context) => const HomeScreen());

      case additionScreen:
        return MaterialPageRoute(builder: (context) => const AdditionScreen());

      case getheringBalanceScreen:
        return MaterialPageRoute(
            builder: (context) => const GatheringBalanceScreen());

      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
      builder: (context) => const Scaffold(
          body: ErrorStateWidget(
        errorMessage: 'Navigation Bug',
      )),
    );
  }

  static String generateInitialRoute() {
    var balance = SharedCache().getBalance(SharedCache().balanceKey);

    if (balance > 0) {
      return homeScreen;
    }
    return getheringBalanceScreen;
  }
}
