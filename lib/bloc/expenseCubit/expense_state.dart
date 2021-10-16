abstract class ExpenseStates {}

class ExpenseInitialState extends ExpenseStates {}

class ExpenseLoadingState extends ExpenseStates {}


class ExpenseCreatedState extends ExpenseStates {}

class ExpenseDeletedState extends ExpenseStates {}

class ExpenseUpdatedState extends ExpenseStates {}

class ExpenseRetrievedState extends ExpenseStates {}

class ExpenseErrorState extends ExpenseStates {
  final String errorMessage;

  ExpenseErrorState(this.errorMessage);
}

// balance states

class AvailableBalanceState extends ExpenseStates {}

class NotAvailableBalanceState extends ExpenseStates {
  final double balance;

  NotAvailableBalanceState(this.balance);
}

class BalanceSettedState extends ExpenseStates {}

// class BalanceRetrievedState extends ExpenseStates {}

// localization
class LocaleChangedState extends ExpenseStates {}
