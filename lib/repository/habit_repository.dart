import 'package:final_tracker/dao/habitsDao.dart';
import 'package:final_tracker/models/habit.dart';

class HabitRepository {
  final habitDao = HabitDao();

  Future getHabits(
          {String query, String type, bool isOrdered, isOrderedByDecrease}) =>
      habitDao.getHabits(
          query: query,
          type: type,
          isOrdered: isOrdered,
          isOrderedByDecrease: isOrderedByDecrease);

  Future getDays(int id) => habitDao.getDays(id);

  Future insertHabit(Habit habit) => habitDao.createHabit(habit);

  Future updateHabit(Habit habit) => habitDao.updateHabit(habit);

  Future deleteHabitById(int id) => habitDao.deleteHabit(id);

  Future deleteAllHabits({String query}) => habitDao.deleteAllHabit();

  Future getHabitById({int id}) => habitDao.getHabitById(id);

  Future addCompletedMark({Habit habit}) => habitDao.addCompletedMark(habit);

  Future getCompletedDate({int id}) => habitDao.getCompletedDate(id);
}
