import 'package:budget_envelopes/core/utils/date.dart';
import 'package:budget_envelopes/features/envelope/data/datasources/local/DAO/envelope_dao.dart';
import 'package:budget_envelopes/features/envelope/data/datasources/local/app_database.dart';
import 'package:budget_envelopes/features/envelope/domain/entities/envelope.dart';
import 'package:budget_envelopes/features/envelope/domain/repositories/envelope_repository.dart';
import 'package:isar/isar.dart';

class EnvelopeRepositoryImpl extends EnvelopeRepository {
  final AppDatabase _appDatabase;
  EnvelopeRepositoryImpl(this._appDatabase);

  @override
  Future<EnvelopeEntity> createEnvelope(EnvelopeEntity envelope) async {
    await _appDatabase
        .insertOrUpdateEnvelope(EnvelopeDao.fromEnvelopeEntity(envelope));
    return envelope;
  }

  @override
  Future<void> deleteEnvelope(int id) async {
    await _appDatabase.deleteEnvelope(id);
  }

  @override
  Future<EnvelopeEntity?> getEnvelope(int id) async {
    var t = await _appDatabase.getEnvelope(id);
    return t?.toEnvelopeEntity();
  }

  @override
  Future<List<EnvelopeEntity>> getEnvelopes() async {
    var val = getYearMonth();
    var envelopes =
        await _appDatabase.db.envelopeDaos.where().monthEqualTo(val).findAll();
    return envelopes.map((e) => e.toEnvelopeEntity()).toList();
  }

  @override
  Future<EnvelopeEntity> updateEnvelope(EnvelopeEntity envelope) async {
    var result = await _appDatabase
        .insertOrUpdateEnvelope(EnvelopeDao.fromEnvelopeEntity(envelope));
    return result.toEnvelopeEntity();
  }

  @override
  Future<List<EnvelopeEntity>> getEnvelopesFor(int yearMonth) async {
    var envelopes = await _appDatabase.db.envelopeDaos
        .where()
        .monthEqualTo(yearMonth)
        .findAll();
    return envelopes.map((e) => e.toEnvelopeEntity()).toList();
  }
}
