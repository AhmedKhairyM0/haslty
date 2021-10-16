import 'package:expense_tracker/core/utils/utils.dart';
import 'package:expense_tracker/data/model/expense_model.dart';
import 'package:expense_tracker/l10n/l10n.dart';
import 'package:expense_tracker/view/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdditionScreen extends StatefulWidget {
  const AdditionScreen({
    Key? key,
    this.expense,
  }) : super(key: key);

  final Expense? expense;

  @override
  State<AdditionScreen> createState() => _AdditionScreenState();
}

class _AdditionScreenState extends State<AdditionScreen> {
  int? transcationId;
  late TextEditingController titleController;
  late TextEditingController expenseController;
  DateTime? chosenDate;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController();
    expenseController = TextEditingController();
    if (thisIsForEditting()) {
      transcationId = widget.expense!.id;
      titleController.text = widget.expense!.title;
      expenseController.text = widget.expense!.amount.toString();
      chosenDate = widget.expense!.date;
    }
  }

  bool thisIsForEditting() => widget.expense != null;

  @override
  void dispose() {
    titleController.dispose();
    expenseController.dispose();
    super.dispose();
  }

  void clear() {
    chosenDate = null;
    titleController.clear();
    expenseController.clear();
  }

  bool isValid() => titleController.text.isNotEmpty;

  Future<bool> backAction() {
    if (isValid()) {
      Navigator.pop(
        context,
        Expense(
          id: transcationId,
          title: titleController.text,
          amount: expenseController.text.isNotEmpty
              ? double.parse(expenseController.text)
              : 0,
          date: chosenDate ?? DateTime.now(),
        ),
      );
    } else {
      Navigator.pop(context);
    }

    return Future(() => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Builder(builder: (context) {
          if (thisIsForEditting()) {
            return Text(AppLocalizations.of(context)!.editExpensePageTitle);
          }
          return Text(AppLocalizations.of(context)!.addExpensePageTitle);
        }),
      ),
      body: WillPopScope(
        onWillPop: backAction,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CustomTextField(
                  controller: titleController,
                  labelText: AppLocalizations.of(context)!.expenseTitle,
                ),
                CustomTextField(
                  controller: expenseController,
                  keyboardType: TextInputType.number,
                  labelText: AppLocalizations.of(context)!.expenseAmount,
                  onChanged: (value) {
                    if (double.parse(value!) < 0) {
                      Utils.showCustomSnackBar(
                          context,
                          AppLocalizations.of(context)!
                              .alertNotFormattedNumber);
                    }
                  },
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Builder(builder: (_) {
                      if (chosenDate == null) {
                        return Text(AppLocalizations.of(context)!.emptyDate);
                      }
                      return Text(
                          DateFormat("MMM dd, yyyy").format(chosenDate!));
                    }),
                    const Spacer(),
                    TextButton(
                      child: Text(AppLocalizations.of(context)!.chooseDate),
                      onPressed: () async {
                        _pickDate(context).then((dateTime) {
                          if (dateTime != null) {
                            setState(() {
                              chosenDate = dateTime;
                            });
                          }
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<DateTime?> _pickDate(BuildContext context) {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year, DateTime.now().month, 1),
      lastDate: DateTime(2050),
    );
  }
}
