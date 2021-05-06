import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:final_tracker/networkUtils/networkUtil.dart';
import 'package:final_tracker/repository/habit_repository.dart';
import 'package:final_tracker/screens/add_edit_screen.dart';
import 'package:final_tracker/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/filtered_habits/filtered_habits_bloc.dart';
import 'blocs/habits/habits_bloc.dart';
import 'blocs/habits/habits_event.dart';
import 'blocs/simple_bloc_observer.dart';
import 'models/habit.dart';

void main() async {
  Bloc.observer = SimpleBlocObserver();
  runApp(
    BlocProvider(
      create: (context) {
        return HabitsBloc(
          habitRepository: HabitRepository(),
        )
          ..add(SynchronizationEvent())
          ..add(HabitsLoaded())
          ..add(HabitsLoaded());
      },
      child: HabitApp(),
    ),
  );
}

class HabitApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit tracker',
      routes: {
        '/': (context) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<FilteredHabitsBloc>(
                create: (context) => FilteredHabitsBloc(
                  habitsBloc: BlocProvider.of<HabitsBloc>(context),
                ),
              ),
            ],
            child: HomeScreen(),
          );
        },
        '/create_habit': (context) {
          return AddEditScreen(
            onSave: (String name, String description, String type,
                int frequency, int period, int priority, int date) {
              BlocProvider.of<HabitsBloc>(context).add(
                HabitAdded(
                  Habit.fromVariables(name, description, type, frequency,
                      period, priority, date),
                ),
              );
            },
            isEditing: false,
          );
        },
      },
    );
  }
}
