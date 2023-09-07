import 'package:budget_envelopes/features/envelope/domain/entities/envelope.dart';
import 'package:budget_envelopes/features/envelope/presentation/bloc/envelope_bloc.dart';
import 'package:currency_formatter/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class EnvelopeTile extends StatefulWidget {
  final EnvelopeEntity envelope;

  const EnvelopeTile({Key? key, required this.envelope}) : super(key: key);

  @override
  State<EnvelopeTile> createState() => _EnvelopeTileState();
}

class _EnvelopeTileState extends State<EnvelopeTile> {
  final CurrencyFormatterSettings _currency = CurrencyFormatterSettings(
      symbol: 'R',
      symbolSide: SymbolSide.left,
      thousandSeparator: ' ',
      decimalSeparator: '.',
      symbolSeparator: ' ');
  var total = 0.0;
  var percent = 1.0;

  @override
  void initState() {
    super.initState();
    for (var transaction in widget.envelope.transactions) {
      total += transaction.amount;
    }
    if (total >= widget.envelope.amountAllocated) {
      percent = 0.0;
    } else {
      percent = (widget.envelope.amountAllocated - total) /
          widget.envelope.amountAllocated;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<EnvelopeBloc>().add(GetEnvelope(widget.envelope.id!));
        context.push('/envelope/details');
      },
      child: Slidable(
        key: ValueKey(widget.envelope),
        endActionPane: ActionPane(motion: const BehindMotion(), children: [
          SlidableAction(
            onPressed: (_) => context
                .read<EnvelopeBloc>()
                .add(DeleteEnvelope(widget.envelope.id!)),
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          )
        ]),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black45),
              borderRadius: const BorderRadius.all(Radius.circular(4)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(child: Text(widget.envelope.name)),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Allocated:"),
                          Text("Used:"),
                        ],
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        children: [
                          Text(CurrencyFormatter.format(
                              widget.envelope.amountAllocated, _currency,
                              enforceDecimals: true)),
                          Text(
                            CurrencyFormatter.format(total, _currency,
                                enforceDecimals: true),
                            style: TextStyle(
                                color: total >= widget.envelope.amountAllocated
                                    ? Colors.red[600]
                                    : null),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  LinearPercentIndicator(
                    lineHeight: 8.0,
                    percent: percent,
                    progressColor: Theme.of(context).primaryColor,
                    barRadius: const Radius.circular(4),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
