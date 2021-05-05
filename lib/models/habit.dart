import 'package:equatable/equatable.dart';

class Habit extends Equatable {
  static String table = 'habits';
  int id;
  String uid;
  String name;
  String description;
  String type;
  int frequency;
  int period;
  List<int> doneDates = List.empty();
  int priority = 0;
  int date;

  String get getPriority {
    Map<int, String> priorityMap = {0: 'Низкий', 1: 'Средний', 2: 'Большой'};
    return priorityMap[this.priority];
  }

  Habit getHabit() {
    return this;
  }

  bool isCompleted() {
    if (doneDates != null) {
      if (doneDates.contains(DateTime.now().day)) {
        return true;
      }
      return false;
    }
    return false;
  }

  Habit copyWith(
      {String uid,
      String name,
      String description,
      String type,
      int frequency,
      int period,
      int priority,
      int date,
      List<int> doneDates}) {
    return Habit(
      id: this.id,
      uid: uid ?? this.uid,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      frequency: frequency ?? this.frequency,
      period: period ?? this.period,
      priority: priority ?? this.priority,
      date: this.date,
      doneDates: doneDates ?? this.doneDates,
    );
  }

  Habit.fromVariables(String name, String description, String type,
      int frequency, int period, int priority, int date) {
    this.name = name;
    this.description = description;
    this.type = type;
    this.frequency = frequency;
    this.period = period;
    this.priority = priority;
    this.date = date;
  }

  Habit(
      {this.id,
      this.uid,
      this.name,
      this.description,
      this.type,
      this.frequency,
      this.period,
      this.priority,
      this.date,
      this.doneDates});

  Habit.fromJson(Map<String, dynamic> json)
      : this.uid = json['uid'],
        this.id = json['id'] != null ? json['id'] : null,
        this.name = json['title'],
        this.description = json['description'],
        this.type = json['type'] is int
            ? json['type'] == 0
                ? 'good'
                : 'bad'
            : json['type'],
        this.frequency = json['frequency'],
        this.period = json['count'],
        this.priority = json['priority'],
        this.date = json['date'],
        this.doneDates = List<int>.from(json['done_dates']);

  static Habit fromMap(Map<String, dynamic> map) {
    return Habit(
        id: map['id'] != null ? map['id'] : null,
        uid: map['uid'],
        name: map['title'],
        description: map['description'],
        type: map['type'],
        frequency: map['frequency'],
        period: map['period'],
        priority: map['priority'],
        date: map['date']);
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'title': name,
      'description': description,
      'type': type,
      'frequency': frequency,
      'period': period,
      'priority': priority,
      'date': date
    };
    if (id != null) {
      map['id'] = id;
    }
    map['uid'] = uid;

    return map;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> habitJson = {
      'title': this.name,
      'description': this.description,
      'type': this.type == 'good' ? 0 : 1,
      'count': this.period,
      'frequency': this.frequency,
      'priority': this.priority,
      'done_dates': this.doneDates,
      'date': this.date,
    };
    if (this.uid != null) {
      habitJson.addAll({'uid': this.uid});
    }
    if (this.id != null) {
      habitJson.addAll({'id': this.id});
    }
    return habitJson;
  }

  String get formatFrequency {
    StringBuffer answer = StringBuffer();
    answer.write('Повторять $frequency');
    String periodStr = period.toString();
    answer.write(getFrequencyString(frequency.toString()));
    answer.write(' в $period');
    answer.write(getPeriodString(periodStr));
    return answer.toString();
  }

  String getPeriodString(String periodStr) {
    if (periodStr[periodStr.length - 1] == '1') {
      if (periodStr.length > 1) {
        if (periodStr[periodStr.length - 2] == '1') {
          return ' дней';
        } else {
          return ' день';
        }
      } else {
        return ' день';
      }
    } else if (['2', '3', '4'].contains(periodStr[periodStr.length - 1])) {
      if (periodStr.length > 1) {
        if (periodStr[periodStr.length - 2] == '1') {
          return ' дней';
        } else {
          return ' дня';
        }
      } else {
        return ' дня';
      }
    } else {
      return ' дней';
    }
  }

  String getFrequencyString(String frequencyStr) {
    if (['2', '3', '4'].contains(frequencyStr[frequencyStr.length - 1])) {
      if (frequencyStr.length > 1) {
        if (frequencyStr[frequencyStr.length - 2] == '1') {
          return ' раз';
        } else {
          return ' разa';
        }
      } else {
        return ' разa';
      }
    } else {
      return ' раз';
    }
  }

  @override
  List<Object> get props => [
        id,
        uid,
        name,
        description,
        type,
        frequency,
        period,
        priority,
        date,
        doneDates
      ];
}
