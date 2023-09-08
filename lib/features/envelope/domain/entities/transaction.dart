import 'package:equatable/equatable.dart';

class TransactionEntity extends Equatable {
  final DateTime time;
  final double amount;
  final String? description;
  final int? id;
  final String name;

  const TransactionEntity({
    this.id,
    required this.time,
    required this.amount,
    this.description,
    required this.name,
  });

  @override
  List<Object?> get props => [id, time, amount, description, name];
}
