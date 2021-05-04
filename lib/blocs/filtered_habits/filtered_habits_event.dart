import 'package:equatable/equatable.dart';
import 'package:final_tracker/models/habit.dart';
import 'package:final_tracker/models/visibility_filter.dart';

abstract class FilteredHabitsEvent extends Equatable {
  const FilteredHabitsEvent();
}

class FilterUpdated extends FilteredHabitsEvent {
  final VisibilityFilter filter;
  final String searchString;

  const FilterUpdated(this.filter, this.searchString);

  @override
  List<Object> get props => [filter];

  @override
  String toString() => 'FilterUpdated { filter: $filter }';
}

class HabitsUpdated extends FilteredHabitsEvent {
  final List<Habit> habits;

  const HabitsUpdated(this.habits);

  @override
  List<Object> get props => [habits];

  @override
  String toString() => 'HabitsUpdated { habits: $habits }';
}
