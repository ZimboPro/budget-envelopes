part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  final List<EnvelopeEntity>? envelopes;
  const HomeState({this.envelopes});

  @override
  List<Object> get props => [];
}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  const HomeLoaded(List<EnvelopeEntity> envelopes)
      : super(envelopes: envelopes);
}
