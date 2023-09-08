import 'package:budget_envelopes/core/utils/date.dart';
import 'package:budget_envelopes/features/envelope/domain/entities/envelope.dart';
import 'package:budget_envelopes/features/envelope/presentation/bloc/envelope_bloc.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class EnvelopeAddPage extends StatefulWidget {
  final int? envelopeId;
  const EnvelopeAddPage({super.key, this.envelopeId});

  @override
  State<EnvelopeAddPage> createState() => _EnvelopeAddPageState();
}

class _EnvelopeAddPageState extends State<EnvelopeAddPage> {
  final name = TextEditingController();
  final description = TextEditingController();
  final amount = TextEditingController();
  final amountFormatter = CurrencyTextInputFormatter(enableNegative: false);
  final _formKey = GlobalKey<FormState>();
  int? monthYear;

  @override
  void initState() {
    super.initState();
    if (BlocProvider.of<EnvelopeBloc>(context).state.entity != null) {
      var s = BlocProvider.of<EnvelopeBloc>(context).state.entity!;
      name.text = s.name;
      description.text = s.description ?? '';
      amount.text = s.amountAllocated.toStringAsFixed(2);
      monthYear = s.monthYear;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("An error has occurred. Please try again later")));
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
            context.pop();
          }),
          title: const Text("Add Envelope"),
        ),
        body: _buildBody(context),
      ),
    );
  }

  _buildBody(
    BuildContext context,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: name,
                decoration: const InputDecoration(hintText: "Envelope name"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Name is required";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                controller: description,
                decoration: const InputDecoration(
                    hintText: "Envelope description (optional)"),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                  controller: amount,
                  inputFormatters: [amountFormatter],
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      hintText: "Envelope allocated amount (optional)"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Amount is required";
                    }
                    return null;
                  }),
              const SizedBox(
                height: 15,
              ),
              ElevatedButton(
                  onPressed: () => onSubmit(context), child: const Text("Save"))
            ],
          ),
        ),
      ),
    );
  }

  onSubmit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      if (widget.envelopeId == null) {
        context.read<EnvelopeBloc>().add(SaveEnvelope(EnvelopeEntity(
            name: name.value.text,
            description: description.text.isNotEmpty ? description.text : null,
            amountAllocated: amountFormatter.getUnformattedValue().toDouble(),
            monthYear: monthYear ?? getYearMonth())));
      } else {
        var s = BlocProvider.of<EnvelopeBloc>(context).state.entity!;
        var t = s.copyWith(
          name: name.value.text,
          description: description.text.isNotEmpty ? description.text : null,
          amountAllocated: amountFormatter.getUnformattedValue().toDouble(),
        );
        context.read<EnvelopeBloc>().add(SaveEditedEnvelope(t));
      }
      context.pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all the fields"),
        ),
      );
    }
  }
}
