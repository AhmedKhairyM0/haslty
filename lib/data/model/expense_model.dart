import 'package:intl/intl.dart';

class Expense {
  int? id;
  String title;
  DateTime date;
  double amount;

  Expense({
    required this.id,
    required this.title,
    required this.date,
    required this.amount,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'date': DateFormat("yyyy-MM-dd").format(date), // e.g "2012-02-27"
        'amount': amount,
      };

  factory Expense.fromMap(Map<String, dynamic> map) => Expense(
        id: map['id'],
        title: map['title'],
        date: DateTime.parse(map['date'] as String),
        amount: map['amount'],
      );

  @override
  String toString() => 'id: $id, title: $title, expense: $amount, date: $date';
}
