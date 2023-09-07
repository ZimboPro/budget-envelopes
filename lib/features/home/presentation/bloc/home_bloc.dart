import 'package:bloc/bloc.dart';
import 'package:budget_envelopes/features/envelope/domain/entities/envelope.dart';
import 'package:equatable/equatable.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeLoading()) {
    on<HomeEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
