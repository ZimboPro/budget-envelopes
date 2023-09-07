import 'package:budget_envelopes/core/usecases/usecase.dart';
import 'package:budget_envelopes/features/envelope/domain/entities/envelope.dart';
import 'package:budget_envelopes/features/envelope/domain/repositories/envelope_repository.dart';

class GetEnvelopesUseCase extends UseCase<List<EnvelopeEntity>, void> {
  final EnvelopeRepository _appDatabase;
  GetEnvelopesUseCase(this._appDatabase);

  @override
  Future<List<EnvelopeEntity>> call({void params}) {
    return _appDatabase.getEnvelopes();
  }
}
