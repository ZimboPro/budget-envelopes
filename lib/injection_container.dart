import 'package:budget_envelopes/features/envelope/data/datasources/local/app_database.dart';
import 'package:budget_envelopes/features/envelope/data/repositories/envelope_repository_impl.dart';
import 'package:budget_envelopes/features/envelope/domain/repositories/envelope_repository.dart';
import 'package:budget_envelopes/features/envelope/domain/usecases/delete_envelope.dart';
import 'package:budget_envelopes/features/envelope/domain/usecases/get_envelope.dart';
import 'package:budget_envelopes/features/envelope/domain/usecases/get_envelopes.dart';
import 'package:budget_envelopes/features/envelope/domain/usecases/save_envelope.dart';
import 'package:budget_envelopes/features/envelope/presentation/bloc/envelope_bloc.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> initialiseDeps() async {
  final database = AppDatabase();
  await database.setup();
  sl.registerSingleton<AppDatabase>(database);

  // Deps
  sl.registerSingleton<EnvelopeRepository>(EnvelopeRepositoryImpl(sl()));

  // use cases
  sl.registerSingleton<GetEnvelopeUseCase>(GetEnvelopeUseCase(sl()));
  sl.registerSingleton<GetEnvelopesUseCase>(GetEnvelopesUseCase(sl()));
  sl.registerSingleton<DeleteEnvelopeUseCase>(DeleteEnvelopeUseCase(sl()));
  sl.registerSingleton<SaveEnvelopeUseCase>(SaveEnvelopeUseCase(sl()));

  // Blocs
  sl.registerFactory<EnvelopeBloc>(() => EnvelopeBloc(sl(), sl(), sl(), sl()));
}
