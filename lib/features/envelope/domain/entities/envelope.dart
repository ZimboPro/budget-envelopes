import 'package:equatable/equatable.dart';

import 'transaction.dart';

class EnvelopeEntity extends Equatable {
  final int? id;
  final String name;
  final String? description;
  final double amountAllocated;
  final int monthYear;
  final List<TransactionEntity> transactions;

  const EnvelopeEntity({
    this.id,
    required this.name,
    this.description,
    required this.amountAllocated,
    required this.monthYear,
    this.transactions = const [],
  });

  @override
  List<Object?> get props =>
      [id, name, description, amountAllocated, monthYear, transactions];

  EnvelopeEntity copy() {
    return EnvelopeEntity(
        id: id,
        name: name,
        description: description,
        amountAllocated: amountAllocated,
        monthYear: monthYear,
        transactions: [
          ...transactions,
        ]);
  }

  EnvelopeEntity copyWith(
      {int? id,
      String? name,
      String? description,
      double? amountAllocated,
      int? monthYear,
      List<TransactionEntity>? transactions}) {
    return EnvelopeEntity(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        amountAllocated: amountAllocated ?? this.amountAllocated,
        monthYear: monthYear ?? this.monthYear,
        transactions: transactions ??
            [
              ...this.transactions,
            ]);
  }
}
