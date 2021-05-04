import 'package:equatable/equatable.dart';
import 'package:final_tracker/models/habit.dart';

abstract class HabitState extends Equatable {
  const HabitState();

  @override
  List<Object> get props => [];
}

class HabitsLoadInProgress extends HabitState {}

class SynchronizationSuccess extends HabitState {}

class SynchronizationFailed extends HabitState {}

class HabitsLoadSuccess extends HabitState {
  final List<Habit> habits;

  const HabitsLoadSuccess([this.habits = const []]);

  @override
  List<Object> get props => [habits];

  @override
  String toString() => 'HabitsLoadSuccess { habits: $habits }';
}

class HabitsLoadFailure extends HabitState {}
