import 'package:budget_envelopes/core/usecases/usecase.dart';
import 'package:budget_envelopes/features/envelope/domain/entities/envelope.dart';
import 'package:budget_envelopes/features/envelope/domain/repositories/envelope_repository.dart';

class SaveEnvelopeUseCase extends UseCase<EnvelopeEntity?, EnvelopeEntity> {
  final EnvelopeRepository _appDatabase;
  SaveEnvelopeUseCase(this._appDatabase);

  @override
  Future<EnvelopeEntity?> call({EnvelopeEntity? params}) {
    return _appDatabase.createEnvelope(params!);
  }
}
