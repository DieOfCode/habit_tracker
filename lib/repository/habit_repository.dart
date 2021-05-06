import 'package:final_tracker/dao/habitsDao.dart';
import 'package:final_tracker/models/habit.dart';
import 'package:final_tracker/networkUtils/networkUtil.dart';

class HabitRepository {
  final habitDao = HabitDao();
  final networkUtils = NetworkUtils();

  Future getHabits(
          {String query, String type, bool isOrdered, isOrderedByDecrease}) =>
      habitDao.getHabits(
          query: query,
          type: type,
          isOrdered: isOrdered,
          isOrderedByDecrease: isOrderedByDecrease);

  Future getDays(int id) => habitDao.getDays(id);

  Future synchronizationWithApi() async {
    final apiData = await networkUtils.get();
    print(apiData);
    List<Habit> apiHabits = apiData.map((element) {
      print(Habit.fromJson(element));
      return Habit.fromJson(element);
    }).toList();
    apiHabits.forEach(
      (element) async {
        Habit habit = await getHabitByUid(uid: element.uid);
        if (habit == null) {
          insertHabit(element, fromApi: true);
        } else {
          if (habit.date < element.date) {
            updateHabitByUid(element);
          }
        }
      },
    );
  }

  Future insertHabit(Habit habit, {bool fromApi = false}) async {
    Map<String, dynamic> preparedHabit;
    if (fromApi) {
      preparedHabit = habit.toMap();
      print('!!!!!!!');
      print(preparedHabit);
    } else {
      String uid = await networkUtils.put(habit: habit.toJson());
      preparedHabit = habit.toMap();
      preparedHabit.addAll({'uid': uid});
    }
    return habitDao.createHabit(habit, preparedHabit, fromApi: fromApi);
  }

  Future updateHabit(Habit habit) {
    networkUtils.put(habit: habit.toJson());
    return habitDao.updateHabit(habit);
  }

  Future updateHabitByUid(Habit habit) => habitDao.updateHabitByUid(habit);

  Future deleteHabitById(int id) => habitDao.deleteHabit(id);

  Future deleteAllHabits({String query}) => habitDao.deleteAllHabit();

  Future getHabitById({int id}) => habitDao.getHabitById(id);

  Future<Habit> getHabitByUid({String uid}) => habitDao.getHabitByUid(uid);

  Future addCompletedMark({Habit habit}) {
    networkUtils.post(date: habit.doneDates.last, habitUid: habit.uid);
    return habitDao.addCompletedMark(habit);
  }

  Future getCompletedDate({int id}) => habitDao.getCompletedDate(id);
}
