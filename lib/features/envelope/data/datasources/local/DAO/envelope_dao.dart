import 'package:budget_envelopes/features/envelope/data/models/envelope.dart';
import 'package:budget_envelopes/features/envelope/data/models/transaction.dart';
import 'package:budget_envelopes/features/envelope/domain/entities/envelope.dart';
import 'package:budget_envelopes/features/envelope/domain/entities/transaction.dart';
import 'package:isar/isar.dart';

part 'envelope_dao.g.dart';

@collection
class EnvelopeDao {
  Id? id;
  String name;
  String? description;
  double amountAllocated;
  @Index(type: IndexType.value)
  int month;

  List<Transaction>? transactions;

  EnvelopeDao(
      {required this.name,
      this.description,
      required this.amountAllocated,
      required this.month,
      this.transactions,
      this.id});

  EnvelopeDao copyWith({
    String? name,
    String? description,
    double? amountAllocated,
    int? month,
    List<Transaction>? transactions,
  }) {
    return EnvelopeDao(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      amountAllocated: amountAllocated ?? this.amountAllocated,
      month: month ?? this.month,
      transactions: transactions ?? this.transactions,
    );
  }

  EnvelopeDao newCopyWith({
    String? name,
    String? description,
    double? amountAllocated,
    int? month,
  }) {
    return EnvelopeDao(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      amountAllocated: amountAllocated ?? this.amountAllocated,
      month: month ?? this.month,
      transactions: null,
    );
  }

  EnvelopeModel toEnvelopeModel() {
    return EnvelopeModel(
      id: id,
      name: name,
      description: description,
      amountAllocated: amountAllocated,
      monthYear: month,
      transactions: transactions != null
          ? transactions!.map((e) => e.toTransactionModel()).toList()
          : const [],
    );
  }

  EnvelopeEntity toEnvelopeEntity() {
    return EnvelopeEntity(
      id: id,
      name: name,
      description: description,
      amountAllocated: amountAllocated,
      monthYear: month,
      transactions: transactions != null
          ? transactions!.map((e) => e.toTransactionEntity()).toList()
          : const [],
    );
  }

  factory EnvelopeDao.fromEnvelope(EnvelopeModel envelope) {
    return EnvelopeDao(
      id: envelope.id,
      name: envelope.name,
      description: envelope.description,
      amountAllocated: envelope.amountAllocated,
      month: envelope.monthYear,
      transactions: envelope.transactions
          .map((e) => Transaction(
                time: e.time,
                amount: e.amount,
                description: e.description,
                name: e.name,
              ))
          .toList(),
    );
  }

  factory EnvelopeDao.fromEnvelopeEntity(EnvelopeEntity envelope) {
    return EnvelopeDao(
      id: envelope.id,
      name: envelope.name,
      description: envelope.description,
      amountAllocated: envelope.amountAllocated,
      month: envelope.monthYear,
      transactions: envelope.transactions
          .map((e) => Transaction(
                time: e.time,
                amount: e.amount,
                description: e.description,
                name: e.name,
              ))
          .toList(),
    );
  }
}

@embedded
class Transaction {
  DateTime? time;
  double? amount;
  String? description;
  String? name;
  Transaction({
    this.time,
    this.amount,
    this.description,
    this.name,
  });

  TransactionModel toTransactionModel() {
    return TransactionModel(
      time: time!,
      amount: amount!,
      description: description,
      name: name!,
    );
  }

  TransactionEntity toTransactionEntity() {
    return TransactionEntity(
      time: time!,
      amount: amount!,
      description: description,
      name: name!,
    );
  }
}
