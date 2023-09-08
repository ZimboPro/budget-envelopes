import 'package:budget_envelopes/features/envelope/domain/entities/envelope.dart';
import 'package:budget_envelopes/features/envelope/presentation/bloc/envelope_bloc.dart';
import 'package:currency_formatter/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class EnvelopeDetails extends StatefulWidget {
  const EnvelopeDetails({Key? key}) : super(key: key);

  @override
  State<EnvelopeDetails> createState() => _EnvelopeDetailsState();
}

class _EnvelopeDetailsState extends State<EnvelopeDetails> {
  final CurrencyFormatterSettings _currency = CurrencyFormatterSettings(
      symbol: 'R',
      symbolSide: SymbolSide.left,
      thousandSeparator: ' ',
      decimalSeparator: '.',
      symbolSeparator: ' ');

  double _balance = 0.0;
  double _used = 0.0;
  EnvelopeEntity? _entity;

  @override
  void initState() {
    super.initState();
    if (BlocProvider.of<EnvelopeBloc>(context).state.entity != null) {
      var used = 0.0;
      _entity = BlocProvider.of<EnvelopeBloc>(context).state.entity;
      for (var transaction in _entity!.transactions) {
        used += transaction.amount;
      }
      _used = used;
      _balance = _entity!.amountAllocated - used;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        BlocProvider.of<EnvelopeBloc>(context).add(const GetEnvelopes());
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(onPressed: () {
            BlocProvider.of<EnvelopeBloc>(context).add(const GetEnvelopes());
            context.pop();
          }),
          title: const Text("Transaction Details"),
          actions: [
            IconButton(
                onPressed: () {
                  context.push('/envelope/edit/${_entity!.id!}');
                },
                icon: const Icon(Icons.edit))
          ],
        ),
        body: _buildBody(context),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              context
                  .read<EnvelopeBloc>()
                  .add(AddingEnvelopeTransaction(_entity!));
              context.push("/envelope/transaction");
            }),
      ),
    );
  }

  _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child:
          BlocConsumer<EnvelopeBloc, EnvelopeState>(listener: (context, state) {
        if (state is EnvelopeLoaded) {
          setState(() {
            var used = 0.0;
            for (var transaction in state.entity!.transactions) {
              used += transaction.amount;
            }
            _used = used;
            _balance = state.entity!.amountAllocated - used;
            _entity = state.entity;
          });
        }
      }, builder: (_, state) {
        if (state is EnvelopeInitial) {
          return const Center(
            child: Column(
              children: [
                Text("Initial"),
                CircularProgressIndicator(),
              ],
            ),
          );
        }
        if (state is EnvelopesLoaded) {
          if (state.entities!.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('An error occurred. Please go back'),
                  ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<EnvelopeBloc>(context)
                          .add(const GetEnvelopes());
                      context.pop();
                    },
                    child: const Text("Go back"),
                  )
                ],
              ),
            );
          }
        }
        if (state is EnvelopeLoaded) {
          return Column(
            children: [
              const SizedBox(
                height: 10.0,
              ),
              Row(
                children: [
                  Expanded(child: Text(state.entity!.name)),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Allocated:"),
                      Text("Balance:"),
                    ],
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    children: [
                      Text(CurrencyFormatter.format(
                          state.entity!.amountAllocated, _currency,
                          enforceDecimals: true)),
                      Text(
                        CurrencyFormatter.format(_balance, _currency,
                            enforceDecimals: true),
                        style: _balance <= 0
                            ? TextStyle(color: Colors.red[600])
                            : null,
                      ),
                    ],
                  )
                ],
              ),
              const Divider(
                thickness: 1,
                height: 20,
                color: Colors.black45,
              ),
              Row(
                children: [
                  const Expanded(child: Text('Transactions')),
                  const Text("Total: "),
                  Text(
                    CurrencyFormatter.format(_used, _currency,
                        enforceDecimals: true),
                    style: _balance <= 0
                        ? TextStyle(color: Colors.red[600])
                        : null,
                  )
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
              Transactions(state: EnvelopeLoaded(_entity))
            ],
          );
        }
        return const SizedBox();
      }),
    );
  }
}

class Transactions extends StatelessWidget {
  final CurrencyFormatterSettings _currency = CurrencyFormatterSettings(
      symbol: 'R',
      symbolSide: SymbolSide.left,
      thousandSeparator: ' ',
      decimalSeparator: '.',
      symbolSeparator: ' ');
  Transactions({
    super.key,
    required this.state,
  });

  final EnvelopeLoaded state;

  @override
  Widget build(BuildContext context) {
    if (state.entity!.transactions.isNotEmpty) {
      return ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: state.entity!.transactions.length,
          shrinkWrap: true,
          separatorBuilder: (context, index) => const SizedBox(
                height: 10,
              ),
          itemBuilder: (context, index) {
            var s = state.entity!.transactions[index];
            return Slidable(
              endActionPane:
                  ActionPane(motion: const BehindMotion(), children: [
                SlidableAction(
                  onPressed: (_) {
                    EnvelopeLoaded toBeRemoved = state.copyWith();
                    toBeRemoved.entity!.transactions.removeAt(index);
                    context
                        .read<EnvelopeBloc>()
                        .add(SaveEnvelopeTransaction(toBeRemoved.entity!));
                  },
                  backgroundColor: const Color(0xFFFE4A49),
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                )
              ]),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black38),
                    borderRadius: BorderRadius.circular(4)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Text(DateFormat.yMd().format(s.time)),
                          Text(DateFormat.Hm().format(s.time)),
                        ],
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(s.name),
                      Expanded(
                        child: Text(
                          CurrencyFormatter.format(s.amount, _currency,
                              enforceDecimals: true),
                          textAlign: TextAlign.right,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          });
    }
    return const Expanded(
        child: Center(child: Text("No transactions have occurred")));
  }
}
