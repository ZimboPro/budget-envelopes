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
}
