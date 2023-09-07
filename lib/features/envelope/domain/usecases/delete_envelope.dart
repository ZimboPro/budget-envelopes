import 'package:budget_envelopes/core/usecases/usecase.dart';
import 'package:budget_envelopes/features/envelope/domain/repositories/envelope_repository.dart';

class DeleteEnvelopeUseCase extends UseCase<void, int> {
  final EnvelopeRepository _appDatabase;
  DeleteEnvelopeUseCase(this._appDatabase);

  @override
  Future<void> call({int? params}) {
    return _appDatabase.deleteEnvelope(params!);
  }
}
