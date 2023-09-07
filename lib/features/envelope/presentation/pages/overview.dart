import 'package:budget_envelopes/features/envelope/domain/entities/envelope.dart';
import 'package:budget_envelopes/features/envelope/presentation/bloc/envelope_bloc.dart';
import 'package:budget_envelopes/features/envelope/presentation/widgets/envelope_tile.dart';
import 'package:currency_formatter/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class OverView extends StatefulWidget {
  const OverView({super.key});

  @override
  State<OverView> createState() => _OverViewState();
}

class _OverViewState extends State<OverView> {
  var total = 0.0;
  var spent = 0.0;

  final CurrencyFormatterSettings _currency = CurrencyFormatterSettings(
      symbol: 'R',
      symbolSide: SymbolSide.left,
      thousandSeparator: ' ',
      decimalSeparator: '.',
      symbolSeparator: ' ');

  @override
  void initState() {
    super.initState();
    if (BlocProvider.of<EnvelopeBloc>(context).state.entities != null) {
      setAmounts(BlocProvider.of<EnvelopeBloc>(context).state.entities!);
    }
  }

  void setAmounts(List<EnvelopeEntity> entities) {
    setState(() {
      total = 0;
      spent = 0;
      for (var element in entities) {
        total += element.amountAllocated;
        for (var transaction in element.transactions) {
          spent += transaction.amount;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Envelope Budget"),
        actions: [
          IconButton(
            icon: const Icon(Icons.email_outlined),
            onPressed: () {
              context.push('/envelope/add');
            },
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return BlocConsumer<EnvelopeBloc, EnvelopeState>(
      listener: (context, state) {
        if (state is EnvelopesLoaded) {
          setAmounts(state.entities!);
        }
      },
      builder: (context, state) {
        if (state is EnvelopeInitial) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is EnvelopeLoaded) {
          return const Center(
            child: Text("Single"),
          );
        }
        if (state is EnvelopesLoaded) {
          if (state.entities!.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("You don't currently have any envelopes"),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton.icon(
                      onPressed: () => context.push("/envelope/add"),
                      icon: const Icon(Icons.email_outlined),
                      label: const Text("Add a new envelope"))
                ],
              ),
            );
          }
          return Column(
            children: [
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: state.entities!.length,
                itemBuilder: (context, index) {
                  return EnvelopeTile(envelope: state.entities![index]);
                },
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                          "Total allocated: ${CurrencyFormatter.format(total, _currency, enforceDecimals: true)}"),
                      Text(
                          "Total spent: ${CurrencyFormatter.format(spent, _currency, enforceDecimals: true)}"),
                    ],
                  ),
                ),
              )
            ],
          );
        }
        return const SizedBox();
      },
    );
  }
}
