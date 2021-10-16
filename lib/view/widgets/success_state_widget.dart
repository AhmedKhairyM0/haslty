import 'package:expense_tracker/bloc/appCubit/app_cubit.dart';
import 'package:expense_tracker/bloc/expenseCubit/expense_cubit.dart';
import 'package:expense_tracker/bloc/expenseCubit/expense_state.dart';
import 'package:expense_tracker/core/core.dart';
import 'package:expense_tracker/core/utils/utils.dart';
import 'package:expense_tracker/data/model/expense_model.dart';
import 'package:expense_tracker/l10n/l10n.dart';
import 'package:expense_tracker/view/screens/addition_screen.dart';
import 'package:expense_tracker/view/widgets/weekly_expenses_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class SuccessStateWidget extends StatelessWidget {
  const SuccessStateWidget({Key? key, required this.selectedBarColor}) : super(key: key);

  final Color selectedBarColor;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpenseCubit, ExpenseStates>(
      builder: (context, state) {
        var cubit = ExpenseCubit.of(context);
        return Column(
          children: [
            WeeklyExpensesCard(selectedColor: selectedBarColor),
            Expanded(
              child: ListView.builder(
                itemCount: cubit.expenses.length,
                // reverse: true,
                itemBuilder: (ctx, index) => Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(NumberFormat("#.00")
                          .format(cubit.expenses[index].amount)),
                      radius: 35,
                    ),
                    title: Text(cubit.expenses[index].title),
                    subtitle: Text(DateFormat("MMM dd, yyyy")
                        .format(cubit.expenses[index].date)),
                    trailing: IconButton(
                      icon:
                          const Icon(Icons.delete, color: Palette.kRefuseColor),
                      onPressed: () {
                        // delete
                        Utils.showCustomDialog(
                          context,
                          title: AppLocalizations.of(context)!
                              .contentDeleteDialog(cubit.expenses[index].title),
                          actions: [
                            TextButton(
                              child: Text(AppLocalizations.of(context)!.delete,
                                  style: const TextStyle(
                                      color: Palette.kRefuseColor)),
                              onPressed: () {
                                cubit.deleteExpense(cubit.expenses[index]);
                                Navigator.pop(context);
                              },
                            ),
                            TextButton(
                              child: Text(AppLocalizations.of(context)!.cancle),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      },
                    ),
                    onTap: () async {
                      Expense? edittingExpense = await Navigator.push<Expense>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AdditionScreen(
                            expense: cubit.expenses[index],
                          ),
                        ),
                      );
                      // update
                      if (edittingExpense != null) {
                        cubit.updateExpense(
                            edittingExpense, cubit.expenses[index].amount);
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
