import 'package:budget_envelopes/features/envelope/domain/entities/transaction.dart';
import 'package:budget_envelopes/features/envelope/presentation/bloc/envelope_bloc.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class TransactionAdd extends StatefulWidget {
  const TransactionAdd({Key? key}) : super(key: key);

  @override
  State<TransactionAdd> createState() => _TransactionAddState();
}

class _TransactionAddState extends State<TransactionAdd> {
  final _formKey = GlobalKey<FormState>();

  final date = TextEditingController();
  DateTime _date = DateTime.now();

  final time = TextEditingController();
  TimeOfDay _time = TimeOfDay.now();

  final name = TextEditingController();

  final description = TextEditingController();

  final _dateFormat = 'dd/MM/yyyy';

  final amountFormatter = CurrencyTextInputFormatter(enableNegative: false);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        BlocProvider.of<EnvelopeBloc>(context).add(const GetEnvelopes());
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(onPressed: () => context.pop()),
          title: const Text("Add Transaction"),
        ),
        body: _buildBody(context),
      ),
    );
  }

  _buildBody(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Name",
                  ),
                  controller: name,
                  validator: (value) {
                    if (value!.isEmpty || value.trim().isEmpty) {
                      return "Please enter a name";
                    }
                    return null;
                  }),
              const SizedBox(
                height: 10,
              ),
              TextField(
                decoration: const InputDecoration(
                  labelText: "Description (Optional)",
                ),
                controller: description,
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Amount",
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    amountFormatter,
                  ],
                  validator: (value) {
                    if (value!.isEmpty || value.trim().isEmpty) {
                      return "Please enter an amount";
                    }
                    return null;
                  }),
              const SizedBox(
                height: 10,
              ),
              TextField(
                  decoration: const InputDecoration(
                    filled: true,
                    prefixIcon: Icon(Icons.calendar_today),
                    labelText: "Date",
                  ),
                  keyboardType: TextInputType.datetime,
                  readOnly: true,
                  controller: date,
                  onTap: () {
                    _showDate(context);
                  }),
              const SizedBox(
                height: 10,
              ),
              TextField(
                  decoration: const InputDecoration(
                    filled: true,
                    prefixIcon: Icon(Icons.alarm),
                    labelText: "Time",
                  ),
                  keyboardType: TextInputType.datetime,
                  readOnly: true,
                  controller: time,
                  onTap: () {
                    _showTime(context);
                  }),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () => context.pop(),
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () => _submitForm(context),
                    child: const Text("Add"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      var s = context.read<EnvelopeBloc>();
      var state = s.state;
      if (state is EnvelopeUpdating) {
        var t = TransactionEntity(
            time: DateTime(
                _date.year, _date.month, _date.day, _time.hour, _time.minute),
            amount: amountFormatter.getUnformattedValue().toDouble(),
            name: name.value.text,
            description: description.value.text);
        EnvelopeState c = state.copyWith();
        c.entity!.transactions.add(t);
        s.add(SaveEnvelopeTransaction(c.entity!));
        // s.state.entity!.transactions.add(TransactionEntity(
        //     time: DateTime(
        //         _date.year, _date.month, _date.day, _time.hour, _time.minute),
        //     amount: amountFormatter.getUnformattedValue().toDouble(),
        //     name: name.value.text,
        //     description: description.value.text));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                "An error has occurred. Please restart the app and try again")));
      }
      GoRouter.of(context).pop();
    }
  }

  Future<void> _showDate(BuildContext context) async {
    var value = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime.now().add(const Duration(days: 31)));
    if (value != null) {
      _date = value;
      date.text = DateFormat(_dateFormat).format(value);
    }
  }

  Future<void> _showTime(BuildContext context) async {
    var value = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (value != null) {
      _time = value;
      final localizations = MaterialLocalizations.of(context);
      time.text = localizations.formatTimeOfDay(value);
    }
  }
}
