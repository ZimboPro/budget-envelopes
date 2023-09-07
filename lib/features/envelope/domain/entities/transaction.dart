import 'package:equatable/equatable.dart';

class TransactionEntity extends Equatable {
  final DateTime time;
  final double amount;
  final String? description;
  final String name;

  const TransactionEntity({
    required this.time,
    required this.amount,
    this.description,
    required this.name,
  });

  @override
  List<Object?> get props => [time, amount, description, name];
}
