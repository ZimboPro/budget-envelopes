import 'package:budget_envelopes/core/usecases/usecase.dart';
import 'package:budget_envelopes/features/envelope/domain/entities/envelope.dart';
import 'package:budget_envelopes/features/envelope/domain/repositories/envelope_repository.dart';

class GetEnvelopeUseCase extends UseCase<EnvelopeEntity?, int> {
  final EnvelopeRepository _appDatabase;
  GetEnvelopeUseCase(this._appDatabase);

  @override
  Future<EnvelopeEntity?> call({int? params}) {
    return _appDatabase.getEnvelope(params!);
  }
}
