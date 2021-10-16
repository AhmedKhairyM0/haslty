import 'package:expense_tracker/data/dataSource/local/expense_cache.dart';
import 'package:expense_tracker/data/dataSource/sharedPref/shared_cache.dart';
import 'package:expense_tracker/data/model/expense_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'expense_state.dart';

class ExpenseCubit extends Cubit<ExpenseStates> {
  ExpenseCubit() : super(ExpenseInitialState());

  static ExpenseCubit of(BuildContext context) =>
      BlocProvider.of<ExpenseCubit>(context);

  List<Expense> expenses = [];

  double balance = 0.0;

  void insertExpense(Expense model) {
    emit(ExpenseLoadingState());
    if (balance >= model.amount) {
      ExpenseCache().insert(model).then((_) {
        decrementBalance(model.amount);
        emit(ExpenseCreatedState());
      }).catchError((error) {
        emit(ExpenseErrorState(error.toString()));
      });
    } else {
      emit(NotAvailableBalanceState(balance));
    }
  }

  void updateExpense(Expense newModel, double oldAmount) {
    emit(ExpenseLoadingState());

    if (newModel.amount <= balance + oldAmount) {
      ExpenseCache().update(newModel).then((_) {
        decrementBalance(-oldAmount + newModel.amount);

        emit(ExpenseUpdatedState());
      }).catchError((error) {
        emit(ExpenseErrorState(error.toString()));
      });
    } else {
      emit(NotAvailableBalanceState(balance));
    }
  }

  void deleteExpense(Expense model) {
    emit(ExpenseLoadingState());

    ExpenseCache().deleteForEver(model).then((value) {
      decrementBalance(-model.amount);
      emit(ExpenseDeletedState());
    }).catchError((error) {
      emit(ExpenseErrorState(error.toString()));
    });
  }

  void deleteAllExpenses() {
    emit(ExpenseLoadingState());
    ExpenseCache().deleteAllForEver().then((_) {
      setBalance(0);
      emit(ExpenseDeletedState());
    }).catchError((error) {
      emit(ExpenseErrorState(error.toString()));
    });
  }

  void getAllExpenses([String table = 'expenses']) {
    emit(ExpenseLoadingState());
    ExpenseCache().getAll(table).then((expenses) {
      this.expenses = expenses;
      calculateExpenses();
      getBalance();

      emit(ExpenseRetrievedState());
    }).catchError((error) {
      emit(ExpenseErrorState(error.toString()));
    });
  }

  void generateError(String errorMessage) {
    emit(ExpenseErrorState(errorMessage));
  }

  // * Calculate expenses for week days
  var weekDays = [
    'Sat',
    'Sun',
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
  ];

  Map<String, double> expensesMap = {};

  void calculateExpenses() {
    for (var day in weekDays) {
      expensesMap[day] = 0;
    }
    for (var expense in expenses) {
      var day = DateFormat("EEE").format(expense.date);
      expensesMap[day] = expensesMap[day]! + expense.amount;
    }
  }

  // balance management

  void decrementBalance(double value) {
    if (balance >= value) {
      balance -= value;
      setBalance(balance);
    } else {
      emit(NotAvailableBalanceState(balance));
    }
  }

  void setBalance(double balance) {
    SharedCache().setBalance(SharedCache().balanceKey, balance).then((isSaved) {
      if (isSaved) {
        this.balance = balance;
        emit(BalanceSettedState());
      }
    }).catchError((error) {});
  }

  void getBalance() {
    balance = SharedCache().getBalance(SharedCache().balanceKey);
  }
}
