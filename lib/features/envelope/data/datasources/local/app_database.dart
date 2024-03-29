import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'DAO/envelope_dao.dart';

class AppDatabase {
  late Isar db;
  AppDatabase();

  Future<void> setup() async {
    final dir = await getApplicationDocumentsDirectory();
    db = await Isar.open(
      [EnvelopeDaoSchema],
      directory: dir.path,
    );
  }

  Future<EnvelopeDao?> getEnvelope(int id) async {
    return await db.envelopeDaos.get(id);
  }

  Future<void> deleteEnvelope(int id) async {
    await db.writeTxn(() async {
      await db.envelopeDaos.delete(id);
    });
  }

  Future<EnvelopeDao> insertOrUpdateEnvelope(EnvelopeDao envelope) async {
    return await db.writeTxn<EnvelopeDao>(() async {
      var id = await db.envelopeDaos.put(envelope);
      envelope.id = id;
      return envelope;
    });
  }
}
