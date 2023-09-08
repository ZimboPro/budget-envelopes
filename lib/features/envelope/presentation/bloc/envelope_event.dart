part of 'envelope_bloc.dart';

abstract class EnvelopeEvent extends Equatable {
  final int? id;
  final EnvelopeEntity? entity;
  const EnvelopeEvent({this.id, this.entity});

  @override
  List<Object> get props => [id!];
}

class GetEnvelopes extends EnvelopeEvent {
  const GetEnvelopes();
}

class GetEnvelope extends EnvelopeEvent {
  const GetEnvelope(int id) : super(id: id);
}

class DeleteEnvelope extends EnvelopeEvent {
  const DeleteEnvelope(int id) : super(id: id);
}

class SaveEnvelope extends EnvelopeEvent {
  const SaveEnvelope(EnvelopeEntity envelope) : super(entity: envelope);
}

class SaveEditedEnvelope extends EnvelopeEvent {
  const SaveEditedEnvelope(EnvelopeEntity envelope) : super(entity: envelope);
}

class SaveEnvelopeTransaction extends EnvelopeEvent {
  const SaveEnvelopeTransaction(EnvelopeEntity envelope)
      : super(entity: envelope);
}

class AddingEnvelopeTransaction extends EnvelopeEvent {
  const AddingEnvelopeTransaction(EnvelopeEntity envelope)
      : super(entity: envelope);
}

class RemovingEnvelopeTransaction extends EnvelopeEvent {
  const RemovingEnvelopeTransaction(EnvelopeEntity envelope)
      : super(entity: envelope);
}
