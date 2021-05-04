import 'package:equatable/equatable.dart';
import 'package:final_tracker/models/habit.dart';
import 'package:final_tracker/models/visibility_filter.dart';

abstract class FilteredHabitsState extends Equatable {
  const FilteredHabitsState();

  @override
  List<Object> get props => [];
}

class FilteredHabitsLoadInProgress extends FilteredHabitsState {}

class FilteredHabitsLoadSuccess extends FilteredHabitsState {
  final List<Habit> filteredHabits;
  final VisibilityFilter activeFilter;
  final String activeSearchWord;

  const FilteredHabitsLoadSuccess(this.filteredHabits, this.activeFilter,
      {this.activeSearchWord});

  @override
  List<Object> get props => [filteredHabits, activeFilter];

  @override
  String toString() {
    return 'FilteredHabitsLoadSuccess { filteredHabits: $filteredHabits, activeFilter: $activeFilter }';
  }
}
