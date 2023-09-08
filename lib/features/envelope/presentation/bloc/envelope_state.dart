part of 'envelope_bloc.dart';

abstract class EnvelopeState extends Equatable {
  final List<EnvelopeEntity>? entities;
  final EnvelopeEntity? entity;
  const EnvelopeState({this.entities, this.entity});

  @override
  List<Object?> get props => [entities, entity];

  dynamic copyWith({List<EnvelopeEntity>? entities, EnvelopeEntity? entity});
}

class EnvelopeInitial extends EnvelopeState {
  const EnvelopeInitial();

  @override
  copyWith({List<EnvelopeEntity>? entities, EnvelopeEntity? entity}) {
    return const EnvelopeInitial();
  }
}

class EnvelopesLoaded extends EnvelopeState {
  const EnvelopesLoaded(List<EnvelopeEntity> entities)
      : super(entities: entities);

  @override
  copyWith({List<EnvelopeEntity>? entities, EnvelopeEntity? entity}) {
    return EnvelopesLoaded(entities ?? [...this.entities!]);
  }
}

class EnvelopeLoaded extends EnvelopeState {
  const EnvelopeLoaded(EnvelopeEntity? entity) : super(entity: entity);

  @override
  copyWith({List<EnvelopeEntity>? entities, EnvelopeEntity? entity}) {
    return EnvelopeLoaded(entity ?? this.entity?.copy());
  }
}

class EnvelopeEditing extends EnvelopeState {
  const EnvelopeEditing(EnvelopeEntity? entity) : super(entity: entity);

  @override
  copyWith({List<EnvelopeEntity>? entities, EnvelopeEntity? entity}) {
    return EnvelopeEditing(entity ?? this.entity?.copy());
  }
}

class EnvelopeUpdating extends EnvelopeState {
  const EnvelopeUpdating(EnvelopeEntity? entity) : super(entity: entity);

  @override
  copyWith({List<EnvelopeEntity>? entities, EnvelopeEntity? entity}) {
    return EnvelopeUpdating(entity ?? this.entity?.copy());
  }
}
