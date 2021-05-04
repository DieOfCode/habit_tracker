import 'package:final_tracker/database/database.dart';
import 'package:final_tracker/models/habit.dart';
import 'package:final_tracker/networkUtils/networkUtil.dart';

class HabitDao {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<void> synchronizationWithApi() async {
    final apiData = await NetworkUtils.get();
    print(apiData);
    List<Habit> apiHabits = apiData.map((element) {
      return Habit.fromJson(element);
    }).toList();
    apiHabits.forEach(
      (element) async {
        Habit habit = await getHabitByUid(element.uid);
        if (habit == null) {
          createHabit(element, fromApi: true);
        } else {
          if (habit.date < element.date) {
            updateHabitByUid(element);
          }
        }
      },
    );
  }

  Future<int> createHabit(Habit habit, {bool fromApi = false}) async {
    Map<String, dynamic> preparedHabit;
    if (fromApi) {
      preparedHabit = habit.toMap();
    } else {
      String uid = await NetworkUtils.put(habit: habit.toJson());
      preparedHabit = habit.toMap();
      preparedHabit.addAll({'uid': uid});
    }
    final db = await dbProvider.database;
    var result = db.insert(Habit.table, preparedHabit);
    if (fromApi) {
      if (habit.doneDates.isNotEmpty) {
        Habit createdHabit = await getHabitByUid(habit.uid);

        for (int date in habit.doneDates) {
          addCompletedMarkInSync(createdHabit.id, date);
        }
      }
    }
    return result;
  }

  Future<List<Habit>> getHabits(
      {List<String> columns,
      String query,
      String type,
      bool isOrdered = false,
      bool isOrderedByDecrease = false}) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result;
    List<Map<String, dynamic>> days;
    try {
      result = await db.query(Habit.table);
      days = await db.query('completedDates');
    } catch (e) {
      print(e);
    }

    List<Habit> habits = [];
    result.forEach((result) {
      List<int> data = days
          .where((element) => element['habit_id'] == result['id'])
          .map<int>((e) => e['date'])
          .toList();
      Habit habit = Habit.fromMap(result);
      habit.doneDates = data;
      habits.add(habit);
    });

    return habits;
  }

  int getId(Map<String, int> map) => map['id'];

  Future<List<int>> getDays(int id) async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> days = await db.rawQuery(
        'SELECT ps.date FROM habits p LEFT OUTER JOIN completedDates ps ON ps.habit_id = ?',
        [id]);
    List<int> daysResult = days.isNotEmpty
        ? days
            .map(
              (habit) => getDay(habit),
            )
            .toList()
        : [];
    return daysResult;
  }

  int getDay(Map<String, dynamic> days) => days['date'];

  Future<int> updateHabit(Habit habit, {bool updatingApi = true}) async {
    final db = await dbProvider.database;
    if (updatingApi) {
      NetworkUtils.put(habit: habit.toJson());
    }
    var result = await db.update(Habit.table, habit.toMap(),
        where: 'id = ?', whereArgs: [habit.id]);
    return result;
  }

  Future<int> updateHabitByUid(Habit habit) async {
    final db = await dbProvider.database;
    var result = await db.update(Habit.table, habit.toMap(),
        where: 'uid = ?', whereArgs: [habit.uid]);
    return result;
  }

  Future<int> deleteHabit(int id) async {
    final db = await dbProvider.database;
    var result = await db.delete(Habit.table, where: 'id = ?', whereArgs: [id]);
    return result;
  }

  Future<Habit> getHabitById(int id) async {
    final db = await dbProvider.database;
    var result =
        await db.query(Habit.table, where: 'id LIKE ?', whereArgs: [id]);
    List<Habit> habits = result.isNotEmpty
        ? result.map((habit) => Habit.fromMap(habit)).toList()
        : [];
    return habits.first;
  }

  Future<Habit> getHabitByUid(String uid) async {
    final db = await dbProvider.database;
    var result =
        await db.query(Habit.table, where: 'uid LIKE ?', whereArgs: [uid]);
    List<Habit> habits = result.isNotEmpty
        ? result.map((habit) => Habit.fromMap(habit)).toList()
        : [];
    return habits.isNotEmpty ? habits.first : null;
  }

  Future<List<int>> getCompletedDate(int id) async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> result = await db.rawQuery(
        'SELECT date FROM completedDates dates WHERE habit_id = ?', [id]);
    List<int> dates =
        result.isNotEmpty ? result.map((e) => fromMap(e)).toList() : [];
    return dates;
  }

  Future<int> addCompletedMark(Habit habit) async {
    final db = await dbProvider.database;
    NetworkUtils.put(habit: habit.toJson());
    int result = await db.insert(
        'completedDates', {'habit_id': habit.id, 'date': habit.doneDates.last});
    updateHabit(habit);
    return result;
  }

  Future<int> addCompletedMarkInSync(int id, int date) async {
    final db = await dbProvider.database;
    int result =
        await db.insert('completedDates', {'habit_id': id, 'date': date});
    return result;
  }

  Future deleteAllHabit() async {
    final db = await dbProvider.database;
    var result = await db.delete(
      Habit.table,
    );

    return result;
  }

  int fromMap(Map<String, dynamic> map) {
    return map['date'];
  }
}
