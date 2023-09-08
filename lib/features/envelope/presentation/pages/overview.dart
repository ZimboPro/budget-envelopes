import 'dart:math';

import 'package:budget_envelopes/features/envelope/domain/entities/envelope.dart';
import 'package:budget_envelopes/features/envelope/presentation/bloc/envelope_bloc.dart';
import 'package:budget_envelopes/features/envelope/presentation/widgets/envelope_tile.dart';
import 'package:currency_formatter/currency_formatter.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:quiver/time.dart';

class OverView extends StatefulWidget {
  const OverView({super.key});

  @override
  State<OverView> createState() => _OverViewState();
}

class _OverViewState extends State<OverView> {
  var total = 0.0;
  var spent = 0.0;
  var maxValue = 100.0;
  List<double> monthDaysAmount = [];
  List<DayDetails> last7DaysAmount = [];

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
      chartData(BlocProvider.of<EnvelopeBloc>(context).state.entities!);
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

  void chartData(List<EnvelopeEntity> envelopes) {
    setState(() {
      var date = DateTime.now();
      var monthAmt = daysInMonth(date.year, date.month);
      var temp = List.generate(monthAmt,
          (index) => DayDetails(DateTime(date.year, date.month, index), 0.0));

      for (var envelope in envelopes) {
        for (var transaction in envelope.transactions) {
          temp[transaction.time.day].amount += transaction.amount;
        }
      }
      var dayOfMonth = max(date.day, 7);
      last7DaysAmount = temp.sublist(dayOfMonth - 6, dayOfMonth + 1);

      var tempMaxValue = last7DaysAmount.map((e) => e.amount).reduce(max);
      maxValue = max(maxValue, tempMaxValue * 1.1);
      monthDaysAmount = temp.map((e) => e.amount).toList();
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              context.push('/envelope/add');
            }),
      ),
    );
  }

  _buildBody() {
    return BlocConsumer<EnvelopeBloc, EnvelopeState>(
      listener: (context, state) {
        if (state is EnvelopesLoaded) {
          setAmounts(state.entities!);
          chartData(state.entities!);
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
              WeekChart(maxValue: maxValue, last7DaysAmount: last7DaysAmount),
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

class DayDetails {
  final DateTime date;
  double amount;

  DayDetails(this.date, this.amount);
}

class WeekChart extends StatelessWidget {
  const WeekChart({
    super.key,
    required this.maxValue,
    required this.last7DaysAmount,
  });

  final double maxValue;
  final List<DayDetails> last7DaysAmount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: SizedBox(
        height: 200,
        child: BarChart(BarChartData(
            maxY: maxValue,
            minY: 0,
            gridData: const FlGridData(show: false),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
                show: true,
                topTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) =>
                            getTitlesWidget(last7DaysAmount[value.toInt()])))),
            barGroups: last7DaysAmount
                .asMap()
                .entries
                .map((e) => BarChartGroupData(x: e.key, barRods: [
                      BarChartRodData(
                          toY: e.value.amount,
                          color: Colors.grey[800],
                          width: 20,
                          borderRadius: BorderRadius.circular(2),
                          backDrawRodData: BackgroundBarChartRodData(
                              show: true,
                              toY: maxValue,
                              color: Colors.grey[200]))
                    ]))
                .toList())),
      ),
    );
  }
}

Widget getTitlesWidget(DayDetails day) {
  return Text(DateFormat.Md().format(day.date));
}
