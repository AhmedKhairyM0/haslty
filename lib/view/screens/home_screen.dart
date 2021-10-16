import 'package:expense_tracker/bloc/appCubit/app_cubit.dart';
import 'package:expense_tracker/bloc/expenseCubit/expense_cubit.dart';
import 'package:expense_tracker/bloc/expenseCubit/expense_state.dart';
import 'package:expense_tracker/core/config/route.dart';
import 'package:expense_tracker/core/core.dart';
import 'package:expense_tracker/l10n/l10n.dart';
import 'package:expense_tracker/view/widgets/contact_dev.dart';
import 'package:expense_tracker/view/widgets/custom_buttons.dart';
import 'package:expense_tracker/view/widgets/empty_state_widget.dart';
import 'package:expense_tracker/view/widgets/error_state_widget.dart';
import 'package:expense_tracker/view/widgets/loading_state_widget.dart';
import 'package:expense_tracker/view/widgets/success_state_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/utils/utils.dart';
import '../../data/model/expense_model.dart';
import 'addition_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    ExpenseCubit.of(context).getAllExpenses();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Map<String, String> locales = {
    "ar": "عربي",
    "en": "English",
  };
  var currentDropdownValue = 'en';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ExpenseCubit, ExpenseStates>(
      listener: (context, state) {
        if (state is ExpenseCreatedState ||
            state is ExpenseUpdatedState ||
            state is ExpenseDeletedState) {
          ExpenseCubit.of(context).getAllExpenses();
        }
        if (state is NotAvailableBalanceState) {
          Utils.showCustomDialog(
            context,
            title: AppLocalizations.of(context)!.alert,
            content: Text(AppLocalizations.of(context)!
                .contentAlertDialog('${state.balance}')),
          );
        }

        if (state is ExpenseErrorState) {
          reportBugsDialog(context, state);
        }
      },
      builder: (context, state) {
        var cubit = ExpenseCubit.of(context);
        return Scaffold(
          appBar: AppBar(
            title: InkWell(
              child: Text(
                AppLocalizations.of(context)!
                    .homePageTitle(cubit.balance.toStringAsFixed(2)),
                style: const TextStyle(fontSize: 18),
              ),
              onTap: () {
                Utils.to(context, RouteGenerator.getheringBalanceScreen);
              },
            ),
          ),
          body: Builder(builder: (context) {
            if (state is ExpenseLoadingState) {
              return const LoadingStateWidget();
            }
            if (ExpenseCubit.of(context).expenses.isEmpty) {
              return EmptyStateWidget(
                image: 'assets/svgs/empty.svg',
                isSvg: true,
                caption: AppLocalizations.of(context)!.emptyExpense,
              );
            }

            if (state is ExpenseErrorState) {
              return ErrorStateWidget(errorMessage: state.errorMessage);
            }

            return SuccessStateWidget(
                selectedBarColor: Palette
                    .kPrimaryColors[AppCubit.of(context).indexSelectedColor]);
          }),
          drawer: Drawer(
            child: Column(
              children: [
                const SizedBox(height: 50),
                Card(
                  elevation: 1,
                  child: ListTile(
                    title: Text(AppLocalizations.of(context)!.resetExpense),
                    onTap: () {
                      Navigator.pop(context);

                      Utils.showCustomDialog(context,
                          title:
                              AppLocalizations.of(context)!.titleDeleteDialog,
                          actions: [
                            TextButton(
                              child: Text(AppLocalizations.of(context)!.cancle),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            TextButton(
                              child: Text(AppLocalizations.of(context)!.delete,
                                  style: const TextStyle(
                                      color: Palette.kRefuseColor)),
                              onPressed: () {
                                cubit.deleteAllExpenses();
                                Navigator.pop(context);
                              },
                            ),
                          ]);
                    },
                  ),
                ),
                Card(
                  elevation: 1,
                  child: Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          title: Text(
                              AppLocalizations.of(context)!.chooseLanguage),
                        ),
                      ),
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: currentDropdownValue,
                            items: ['ar', 'en']
                                .map(
                                  (item) => DropdownMenuItem(
                                    value: item,
                                    child: Text(locales[item]!),
                                  ),
                                )
                                .toList(),
                            // value:
                            onChanged: (value) {
                              if (value != null) {
                                currentDropdownValue = value;
                                AppCubit.of(context).setLocale(value);
                                Navigator.pop(context);
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Card(
                  elevation: 1,
                  margin: const EdgeInsets.all(8),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppLocalizations.of(context)!.choosePreferredTheme,
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            CircleButton(
                              color: Palette.kPrimaryColors[0],
                              onTap: () {
                                AppCubit.of(context).setTheme(0);
                                Navigator.pop(context);
                              },
                            ),
                            CircleButton(
                              color: Palette.kPrimaryColors[1],
                              onTap: () {
                                AppCubit.of(context).setTheme(1);
                                Navigator.pop(context);
                              },
                            ),
                            CircleButton(
                              color: Palette.kPrimaryColors[2],
                              onTap: () {
                                AppCubit.of(context).setTheme(2);
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                const ContactWithDev(),
                const SizedBox(height: 100),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              addExpense(context);
            },
          ),
        );
      },
    );
  }

  addExpense(BuildContext ctx) {
    var cubit = ExpenseCubit.of(ctx);
    if (cubit.balance > 0) {
      return () async {
        var newTransaction = await Navigator.push<Expense>(
            context, MaterialPageRoute(builder: (_) => const AdditionScreen()));
        if (newTransaction != null) {
          cubit.insertExpense(newTransaction);
        } else {
          // show snack bar with discarding expense
          Utils.showCustomSnackBar(
            ctx,
            AppLocalizations.of(context)!.discardContent,
          );
        }
        AppCubit.of(context).changeFirstTime();
      }();
    }
    return Utils.showCustomDialog(context,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/bankrupt.png'),
            Text(
              AppLocalizations.of(context)!.noMoney,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text(AppLocalizations.of(context)!.cancle,
                style: const TextStyle(color: Palette.kRefuseColor)),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: Text(AppLocalizations.of(context)!.addBalance),
            onPressed: () {
              Navigator.pop(context);
              Utils.to(
                context,
                RouteGenerator.getheringBalanceScreen,
              );
            },
          ),
        ]);
  }

  Future reportBugsDialog(BuildContext context, ExpenseErrorState state) async {
    return Utils.showCustomDialog(context,
        title: AppLocalizations.of(context)!.titleReportBugs,
        content: Text(
          AppLocalizations.of(context)!.contentReportBugs,
        ),
        actions: [
          TextButton(
            child: Text(AppLocalizations.of(context)!.skip,
                style: const TextStyle(color: Palette.kRefuseColor)),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: Text(AppLocalizations.of(context)!.report,
                style: const TextStyle(color: Palette.kAcceptColor)),
            onPressed: () async {
              // send email with error
              await Utils.reportBugs(
                  subject: state.errorMessage, body: state.errorMessage);
              Navigator.pop(context);
            },
          ),
        ]);
  }
}
