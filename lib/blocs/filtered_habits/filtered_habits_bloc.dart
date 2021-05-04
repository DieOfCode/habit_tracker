import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:final_tracker/blocs/habits/habits_bloc.dart';
import 'package:final_tracker/blocs/habits/habits_state.dart';
import 'package:final_tracker/models/habit.dart';
import 'package:final_tracker/models/visibility_filter.dart';
import 'package:meta/meta.dart';

import 'filtered_habits_event.dart';
import 'filtered_habits_state.dart';

class FilteredHabitsBloc
    extends Bloc<FilteredHabitsEvent, FilteredHabitsState> {
  final HabitsBloc habitsBloc;
  StreamSubscription habitsSubscription;

  FilteredHabitsBloc({@required this.habitsBloc})
      : super(
          habitsBloc.state is HabitsLoadSuccess
              ? FilteredHabitsLoadSuccess(
                  (habitsBloc.state as HabitsLoadSuccess).habits,
                  VisibilityFilter.down,
                )
              : FilteredHabitsLoadInProgress(),
        ) {
    habitsSubscription = habitsBloc.stream.listen((state) {
      if (state is HabitsLoadSuccess) {
        add(HabitsUpdated((habitsBloc.state as HabitsLoadSuccess).habits));
      }
    });
  }

  @override
  Stream<FilteredHabitsState> mapEventToState(
      FilteredHabitsEvent event) async* {
    if (event is FilterUpdated) {
      yield* _mapFilterUpdatedToState(event);
    } else if (event is HabitsUpdated) {
      yield* _mapHabitsUpdatedToState(event);
    }
  }

  Stream<FilteredHabitsState> _mapFilterUpdatedToState(
    FilterUpdated event,
  ) async* {
    if (habitsBloc.state is HabitsLoadSuccess) {
      yield FilteredHabitsLoadSuccess(
        _mapHabitsToFilteredHabits(
            (habitsBloc.state as HabitsLoadSuccess).habits,
            event.filter,
            event.searchString),
        event.filter,
      );
    }
  }

  Stream<FilteredHabitsState> _mapHabitsUpdatedToState(
    HabitsUpdated event,
  ) async* {
    final visibilityFilter = state is FilteredHabitsLoadSuccess
        ? (state as FilteredHabitsLoadSuccess).activeFilter
        : VisibilityFilter.down;
    yield FilteredHabitsLoadSuccess(
      _mapHabitsToFilteredHabits((habitsBloc.state as HabitsLoadSuccess).habits,
          visibilityFilter, null),
      visibilityFilter,
    );
  }

  List<Habit> _mapHabitsToFilteredHabits(
      List<Habit> habits, VisibilityFilter filter, String searchString) {
    if (filter == VisibilityFilter.up) {
      habits.sort((a, b) => a.date.compareTo(b.date));
    } else if (filter == VisibilityFilter.down || filter == null) {
      habits.sort((b, a) => a.date.compareTo(b.date));
    }
    if (searchString != null) {
      return habits
          .where((element) => element.name.contains(searchString))
          .toList();
    }
    return habits;
  }

  @override
  Future<void> close() {
    habitsSubscription.cancel();
    return super.close();
  }
}
