import 'package:equatable/equatable.dart';
import 'package:final_tracker/models/habit.dart';

abstract class HabitsEvent extends Equatable {
  const HabitsEvent();

  @override
  List<Object> get props => [];
}

class HabitsLoaded extends HabitsEvent {}

class SynchronizationEvent extends HabitsEvent {}

class HabitAdded extends HabitsEvent {
  final Habit habit;

  const HabitAdded(this.habit);

  @override
  List<Object> get props => [habit];

  @override
  String toString() => 'HabitAdded { habit: $habit }';
}

class HabitUpdateCompleted extends HabitsEvent {
  final Habit habit;
  final List<Habit> filteredHabit;

  const HabitUpdateCompleted(this.habit, this.filteredHabit);

  @override
  List<Object> get props => [habit];

  @override
  String toString() => 'HabitCompleted { habit: $habit }';
}

class HabitUpdated extends HabitsEvent {
  final Habit habit;

  const HabitUpdated(this.habit);

  @override
  List<Object> get props => [habit];

  @override
  String toString() => 'HabitUpdated { updatedHabit: $habit }';
}

class HabitDeleted extends HabitsEvent {
  final Habit habit;

  const HabitDeleted(this.habit);

  @override
  List<Object> get props => [habit];

  @override
  String toString() => 'HabitDeleted { habit: $habit }';
}
