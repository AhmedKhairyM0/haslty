import 'package:expense_tracker/bloc/expenseCubit/expense_cubit.dart';
import 'package:expense_tracker/bloc/expenseCubit/expense_state.dart';
import 'package:expense_tracker/core/config/route.dart';
import 'package:expense_tracker/core/utils/utils.dart';
import 'package:expense_tracker/l10n/l10n.dart';
import 'package:expense_tracker/view/widgets/custom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../widgets/custom_text_field.dart';

class GatheringBalanceScreen extends StatefulWidget {
  const GatheringBalanceScreen({Key? key}) : super(key: key);

  @override
  State<GatheringBalanceScreen> createState() => _GatheringBalanceScreenState();
}

class _GatheringBalanceScreenState extends State<GatheringBalanceScreen> {
  late TextEditingController balanceController;

  @override
  void initState() {
    super.initState();
    balanceController = TextEditingController();
  }

  @override
  void dispose() {
    balanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/svgs/savings.svg',
                  width: 200,
                  height: 200,
                ),
                CustomTextField(
                  controller: balanceController,
                  labelText: AppLocalizations.of(context)!.balanceLabel,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 30),
                BlocBuilder<ExpenseCubit, ExpenseStates>(
                  builder: (context, state) {
                    return GeneralButton(
                      label: AppLocalizations.of(context)!.trackBalance,
                      onPressed: () {
                        if (balanceController.text.isNotEmpty) {
                          var balance = double.parse(balanceController.text);
                          if (balance > 0) {
                            ExpenseCubit.of(context).setBalance(balance);
                            ExpenseCubit.of(context)
                                .setWeeklyTotalBalance(balance);

                            Utils.toAndFinish(
                                context, RouteGenerator.homeScreen);
                          } else {
                            Utils.showCustomSnackBar(
                                context,
                                AppLocalizations.of(context)!
                                    .alertNotFormattedNumber);
                          }
                        } else {
                          Utils.showCustomSnackBar(
                            context,
                            AppLocalizations.of(context)!.formattedErrorMessage,
                          );
                        }
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
