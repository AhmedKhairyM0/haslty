import 'package:expense_tracker/data/dataSource/sharedPref/shared_cache.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_state.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppIntialState());

  static AppCubit of(BuildContext context) =>
      BlocProvider.of<AppCubit>(context);

  bool isNotFirstTime = false;
  void changeFirstTime() async {
    isNotFirstTime = true;
    await SharedCache()
        .setFirstTime(SharedCache().firstOpenKey, isNotFirstTime);
    emit(FirstOpenState());
  }

  String locale = 'en';
  void setLocale(String locale) async {
    await SharedCache().setLocale(SharedCache().localeKey, locale);
    this.locale = locale;
    emit(AppChangedLocaleState());
  }

  void getLocale() {
    locale = SharedCache().getLocale(SharedCache().localeKey);
    emit(AppChangedLocaleState());
  }

  int indexSelectedColor = 0;
  void setTheme(int index) async {
    indexSelectedColor = index;
    await SharedCache().setTheme(SharedCache().themeKey, indexSelectedColor);
    emit(AppChangedThemeState());
  }

  void getTheme() {
    indexSelectedColor = SharedCache().getTheme(SharedCache().themeKey);
    emit(AppChangedThemeState());
  }
}
