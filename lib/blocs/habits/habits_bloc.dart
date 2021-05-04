import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:final_tracker/models/habit.dart';
import 'package:final_tracker/repository/habit_repository.dart';
import 'package:meta/meta.dart';

import 'habits_event.dart';
import 'habits_state.dart';

class HabitsBloc extends Bloc<HabitsEvent, HabitState> {
  final HabitRepository habitRepository;

  HabitsBloc({@required this.habitRepository}) : super(HabitsLoadInProgress());

  @override
  Stream<HabitState> mapEventToState(event) async* {
    if (event is HabitAdded) {
      yield* _mapHabitAddedToState(event);
    } else if (event is HabitsLoaded) {
      yield* _mapHabitsLoadedToState();
    } else if (event is HabitUpdated) {
      yield* _mapHabitUpdatedToState(event);
    } else if (event is HabitUpdateCompleted) {
      yield* _mapHabitsUpdateCompletedToState(event);
    } else if (event is SynchronizationEvent) {
      yield* _synchronizationWithApi();
    }
  }

  Stream<HabitState> _synchronizationWithApi() async* {
    try {
      await this.habitRepository.habitDao.synchronizationWithApi();
      yield SynchronizationSuccess();
    } catch (exception) {
      print(exception);
      yield SynchronizationFailed();
    }
  }

  Stream<HabitState> _mapHabitsLoadedToState() async* {
    try {
      List<Habit> habits = await this.habitRepository.getHabits();
      yield HabitsLoadSuccess(
        habits,
      );
    } catch (exception) {
      yield HabitsLoadFailure();
    }
  }

  Stream<HabitState> _mapHabitAddedToState(HabitAdded event) async* {
    if (state is HabitsLoadSuccess) {
      await _saveHabits(event.habit);
      final List<Habit> updatedHabits = await habitRepository.getHabits();
      yield HabitsLoadSuccess(updatedHabits);
    }
  }

  Stream<HabitState> _mapHabitUpdatedToState(HabitUpdated event) async* {
    if (state is HabitsLoadSuccess) {
      final List<Habit> updatedHabits =
          (state as HabitsLoadSuccess).habits.map((habit) {
        return habit.id == event.habit.id ? event.habit : habit;
      }).toList();
      yield HabitsLoadSuccess(updatedHabits);
      _updateHabit(event.habit);
    }
  }

  Stream<HabitState> _mapHabitsUpdateCompletedToState(
      HabitUpdateCompleted event) async* {
    if (state is HabitsLoadSuccess) {
      // final List<Habit> updatedHabits =
      //     (state as HabitsLoadSuccess).habits.map((habit) {
      //   return habit.id == event.habit.id ? event.habit : habit;
      // }).toList();
      yield HabitsLoadSuccess(event.filteredHabit);
      _completedHabits(event.habit);
    }
  }

  Future _saveHabits(Habit habit) {
    return habitRepository.insertHabit(habit);
  }

  Future _completedHabits(Habit habit) {
    habit.date += 1;
    return habitRepository.addCompletedMark(habit: habit);
  }

  Future _updateHabit(Habit habit) {
    habit.date += 1;
    return Future.wait<dynamic>([habitRepository.updateHabit(habit)]);
  }
}
