import 'package:final_tracker/models/habit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HabitItem extends StatelessWidget {
  final GestureTapCallback onTap;
  final ValueChanged<bool> onCheckboxChanged;
  final Habit habit;

  HabitItem({
    Key key,
    @required this.onTap,
    @required this.onCheckboxChanged,
    @required this.habit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Checkbox(
        value: habit.isCompleted(),
        onChanged: onCheckboxChanged,
      ),
      title: Text(
        habit.name,
        style: Theme.of(context).textTheme.headline6,
      ),
      subtitle: Text(
        habit.formatFrequency,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.subtitle1,
      ),
    );
  }
}
