import 'package:bloc/bloc.dart';
import 'package:budget_envelopes/features/envelope/domain/entities/envelope.dart';
import 'package:budget_envelopes/features/envelope/domain/usecases/delete_envelope.dart';
import 'package:budget_envelopes/features/envelope/domain/usecases/get_envelope.dart';
import 'package:budget_envelopes/features/envelope/domain/usecases/get_envelopes.dart';
import 'package:budget_envelopes/features/envelope/domain/usecases/save_envelope.dart';
import 'package:equatable/equatable.dart';

part 'envelope_event.dart';
part 'envelope_state.dart';

class EnvelopeBloc extends Bloc<EnvelopeEvent, EnvelopeState> {
  final DeleteEnvelopeUseCase _delete;
  final GetEnvelopeUseCase _get;
  final GetEnvelopesUseCase _getAll;
  final SaveEnvelopeUseCase _save;

  EnvelopeBloc(this._delete, this._get, this._getAll, this._save)
      : super(const EnvelopeInitial()) {
    on<DeleteEnvelope>(onDeleteEnvelope);
    on<GetEnvelope>(onGetEnvelope);
    on<GetEnvelopes>(onGetEnvelopes);
    on<SaveEnvelope>(onSaveEnvelope);
    on<SaveEditedEnvelope>(onSaveEditedEnvelope);
    on<SaveEnvelopeTransaction>(onSaveEnvelopeTransaction);
    on<AddingEnvelopeTransaction>(onAddingEnvelopeTransaction);
    on<RemovingEnvelopeTransaction>(onRemovingEnvelopeTransaction);
  }

  void onDeleteEnvelope(
      DeleteEnvelope envelope, Emitter<EnvelopeState> emit) async {
    await _delete.call(params: envelope.id);
    final envelopes = await _getAll.call();
    emit(EnvelopesLoaded(envelopes));
  }

  void onGetEnvelope(GetEnvelope event, Emitter<EnvelopeState> emit) async {
    final envelope = await _get.call(params: event.id);
    emit(EnvelopeLoaded(envelope));
  }

  void onGetEnvelopes(
      GetEnvelopes envelope, Emitter<EnvelopeState> emit) async {
    final envelopes = await _getAll.call();
    emit(EnvelopesLoaded(envelopes));
  }

  void onSaveEnvelope(SaveEnvelope event, Emitter<EnvelopeState> emit) async {
    final _ = await _save.call(params: event.entity);
    final envelopes = await _getAll.call();
    emit(EnvelopesLoaded(envelopes));
  }

  void onSaveEditedEnvelope(
      SaveEditedEnvelope event, Emitter<EnvelopeState> emit) async {
    final envelope = await _save.call(params: event.entity);
    emit(EnvelopeLoaded(envelope));
  }

  void onSaveEnvelopeTransaction(
      SaveEnvelopeTransaction event, Emitter<EnvelopeState> emit) async {
    final _ = await _save.call(params: event.entity);
    final envelope = await _get.call(params: event.entity!.id);
    emit(EnvelopeLoaded(envelope));
  }

  void onAddingEnvelopeTransaction(
      AddingEnvelopeTransaction event, Emitter<EnvelopeState> emit) async {
    final _ = await _save.call(params: event.entity);
    final envelope = await _get.call(params: event.entity!.id);
    emit(EnvelopeUpdating(envelope));
  }

  void onRemovingEnvelopeTransaction(
      RemovingEnvelopeTransaction event, Emitter<EnvelopeState> emit) async {
    final _ = await _save.call(params: event.entity);
    final envelope = await _get.call(params: event.entity!.id);
    emit(EnvelopeLoaded(envelope));
  }
}
