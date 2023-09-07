import 'package:budget_envelopes/features/envelope/domain/entities/envelope.dart';

import 'transaction.dart';

class EnvelopeModel extends EnvelopeEntity {
  EnvelopeModel(
      {int? id,
      required String name,
      String? description,
      required double amountAllocated,
      List<TransactionModel> transactions = const [],
      required int monthYear})
      : super(
            id: id,
            name: name,
            description: description,
            amountAllocated: amountAllocated,
            monthYear: monthYear,
            transactions: transactions);
}
