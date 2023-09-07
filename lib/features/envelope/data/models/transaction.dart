import 'package:budget_envelopes/features/envelope/domain/entities/transaction.dart';

class TransactionModel extends TransactionEntity {
  const TransactionModel(
      {required super.time,
      required super.amount,
      required super.name,
      super.description});
}
