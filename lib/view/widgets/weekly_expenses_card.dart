import 'package:expense_tracker/bloc/appCubit/app_cubit.dart';
import 'package:expense_tracker/bloc/appCubit/app_state.dart';
import 'package:expense_tracker/bloc/expenseCubit/expense_cubit.dart';
import 'package:expense_tracker/bloc/expenseCubit/expense_state.dart';
import 'package:expense_tracker/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'fractional_bar.dart';

class WeeklyExpensesCard extends StatelessWidget {
  const WeeklyExpensesCard({
    Key? key,
    required this.selectedColor,
  }) : super(key: key);

  final Color selectedColor;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpenseCubit, ExpenseStates>(
      builder: (context, state) {
        var cubit = ExpenseCubit.of(context);
        return BlocBuilder<AppCubit, AppStates>(
          builder: (context, state) {
            return Card(
              elevation: 8,
              margin: const EdgeInsets.all(20),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: cubit.weekDays.map((day) {
                    return FractionalExpenses(
                      expenses: cubit.expensesMap[day] ?? 0.0,
                      balance: cubit.balance / 7.0,
                      day: weekDayss[AppCubit.of(context).locale][day],
                      selectedColor: Palette.kPrimaryColors[
                          AppCubit.of(context).indexSelectedColor],
                    );
                  }).toList(),
                ),
              ),
            );
          },
        );
      },
    );
  }

  static Map weekDayss = {
    "ar": {
      "Sat": "سبت",
      "Sun": "حد",
      "Mon": "اثنين",
      "Tue": "ثلاثاء",
      "Wed": "اربعاء",
      "Thu": "خميس",
      "Fri": "جمعة",
    },
    "en": {
      "Sat": "Sat",
      "Sun": "Sun",
      "Mon": "Mon",
      "Tue": "Tue",
      "Wed": "Wed",
      "Thu": "Thu",
      "Fri": "Fri",
    },
  };
}
