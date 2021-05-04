import 'package:final_tracker/blocs/blocs.dart';
import 'package:final_tracker/models/habit.dart';
import 'package:final_tracker/screens/add_edit_screen.dart';
import 'package:final_tracker/widgets/habit_item.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'loading_indicator.dart';

class FilteredHabits extends StatelessWidget {
  final String type;

  FilteredHabits({Key key, this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilteredHabitsBloc, FilteredHabitsState>(
      builder: (context, state) {
        if (state is FilteredHabitsLoadInProgress) {
          return LoadingIndicator();
        } else if (state is FilteredHabitsLoadSuccess) {
          final habits = state.filteredHabits
              .where((element) => element.type == type)
              .toList();
          return ListView.builder(
            itemCount: habits.length,
            itemBuilder: (BuildContext context, int index) {
              final habit = habits[index];
              return HabitItem(
                habit: habit,
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return AddEditScreen(
                          isEditing: true,
                          habit: habit,
                          onUpdate: (Habit habit) {
                            BlocProvider.of<HabitsBloc>(context)
                                .add(HabitUpdated(habit));
                          },
                        );
                      },
                    ),
                  );
                },
                onCheckboxChanged: (_) {
                  List<int> updateCompleted = habit.doneDates.toList();
                  if (!habit.isCompleted()) {
                    updateCompleted.add(DateTime.now().day);
                    habit.copyWith(doneDates: updateCompleted);
                    List<Habit> updatedHabits = habits.map((previousHabit) {
                      return previousHabit.id == habit.id
                          ? habit.copyWith(doneDates: updateCompleted)
                          : previousHabit;
                    }).toList();

                    BlocProvider.of<HabitsBloc>(context).add(
                      HabitUpdateCompleted(
                          habit.copyWith(doneDates: updateCompleted),
                          updatedHabits),
                    );

                    if (updateCompleted.length >= habit.frequency) {
                      if (habit.type == 'bad') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Хватит это делать'),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('You are breathtaking!'),
                          ),
                        );
                      }
                    } else {
                      int balance = habit.frequency - updateCompleted.length;
                      if (habit.type == 'bad') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Можете выполнить еще $balance"),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Стоит выполнить еще $balance"),
                          ),
                        );
                      }
                    }
                  }
                },
              );
            },
          );
        } else {
          return Container();
        }
      },
    );
  }
}
