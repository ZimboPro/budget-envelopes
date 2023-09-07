part of 'month_bloc.dart';

abstract class MonthState extends Equatable {
  const MonthState();  

  @override
  List<Object> get props => [];
}
class MonthInitial extends MonthState {}
