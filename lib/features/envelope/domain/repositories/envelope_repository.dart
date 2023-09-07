import 'package:budget_envelopes/features/envelope/domain/entities/envelope.dart';

abstract class EnvelopeRepository {
  Future<List<EnvelopeEntity>> getEnvelopes();
  Future<List<EnvelopeEntity>> getEnvelopesFor(int yearMonth);
  Future<EnvelopeEntity?> getEnvelope(int id);
  Future<EnvelopeEntity> createEnvelope(EnvelopeEntity envelope);
  Future<EnvelopeEntity> updateEnvelope(EnvelopeEntity envelope);
  Future<void> deleteEnvelope(int id);
}
