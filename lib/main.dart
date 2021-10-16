import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/appCubit/app_cubit.dart';
import 'bloc/appCubit/app_state.dart';
import 'bloc/expenseCubit/expense_cubit.dart';
import 'core/config/route.dart';
import 'core/palette.dart';
import 'data/dataSource/local/expense_cache.dart';
import 'data/dataSource/sharedPref/shared_cache.dart';
import 'l10n/l10n.dart';

// TODO: clear expenses list at the weekend

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await ExpenseCache().init(); // open connection to database
  await SharedCache.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppCubit>(create: (_) => AppCubit()..getLocale()),
        BlocProvider<ExpenseCubit>(create: (_) => ExpenseCubit()),
      ],
      child: BlocBuilder<AppCubit, AppStates>(
        builder: (context, state) {
          return MaterialApp(
            title: 'HaslTy',
            debugShowCheckedModeBanner: false,
            // Theming
            theme: ThemeData(
              scaffoldBackgroundColor: Colors.white,
              primarySwatch: Palette
                  .kPrimaryColors[AppCubit.of(context).indexSelectedColor],
            ),
            // Localization
            locale: Locale(AppCubit.of(context).locale),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            // Routing
            onGenerateRoute: RouteGenerator.onGenerate,
            initialRoute: RouteGenerator.generateInitialRoute(),
          );
        },
      ),
    );
  }
}
