import 'package:final_tracker/models/habit.dart';
import 'package:final_tracker/widgets/custom_input_form.dart';
import 'package:flutter/material.dart';

typedef OnSaveCallback = Function(String name, String description, String type,
    int frequency, int period, int priority, int date);

typedef OnUpdateCallback = Function(Habit habit);

class AddEditScreen extends StatefulWidget {
  final Habit habit;
  final OnSaveCallback onSave;
  final OnUpdateCallback onUpdate;
  final bool isEditing;

  AddEditScreen({this.onSave, this.isEditing, Habit habit, this.onUpdate})
      : this.habit = isEditing ? habit : Habit();

  @override
  _AddEditScreenState createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _name;
  String _description;
  String _type;
  int _frequency;
  int _period;
  String _priority;

  bool get isEditing => widget.isEditing;

  Habit get habit => widget.habit;

  @override
  void initState() {
    super.initState();
    setState(() {
      _name = isEditing ? habit.name : '';
      _description = isEditing ? habit.description : '';
      _type = isEditing ? habit.type : 'good';
      _priority = isEditing ? habit.getPriority : 'Низкий';
      if (isEditing) {
        _period = habit.period;
        _frequency = habit.frequency;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(),
        title: Text(
          isEditing ? 'Редактируемая привычка' : 'Новая привычка',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CustomInputForm(
                  formName: 'Название привычки',
                  label: 'Введите название привычки',
                  onChanged: (value) {
                    setState(() {
                      _name = value;
                    });
                  },
                  initialValue: _name,
                ),
                CustomInputForm(
                  formName: 'Описание',
                  label: 'Введите описание привычки',
                  onChanged: (value) {
                    setState(() {
                      _description = value;
                    });
                  },
                  initialValue: _description,
                ),
                getTypeButton(),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Периодичность',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        getFrequencyInput(),
                      ],
                    ),
                  ),
                ),
                getPrioritySelector(),
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(vertical: 18, horizontal: 30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        // primary: kMainComponentColor,
                      ),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          Map<String, int> priorityMap = {
                            'Низкий': 0,
                            'Средний': 1,
                            'Большой': 2
                          };

                          isEditing
                              ? widget.onUpdate(Habit(
                                  id: habit.id,
                                  uid: habit.uid,
                                  name: _name,
                                  description: _description,
                                  type: _type,
                                  frequency: _frequency,
                                  period: _period,
                                  date: habit.date,
                                  priority: priorityMap[_priority],
                                  doneDates: habit.doneDates))
                              : widget.onSave(
                                  _name,
                                  _description,
                                  _type,
                                  _frequency,
                                  _period,
                                  priorityMap[_priority],
                                  DateTime.now().day);
                          Navigator.pop(context);
                        }
                      },
                      child: Text('Сохранить'),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container getTypeButton() {
    return Container(
      child: Column(
        children: [
          ListTile(
            title: const Text('Хорошая'),
            leading: Radio(
              materialTapTargetSize: MaterialTapTargetSize.padded,
              onChanged: (String value) {
                setState(() {
                  _type = value;
                });
              },
              value: 'good',
              groupValue: _type,
            ),
          ),
          ListTile(
            title: const Text('Плохая'),
            leading: Radio(
              onChanged: (String value) {
                setState(() {
                  _type = value;
                });
              },
              value: 'bad',
              groupValue: _type,
            ),
          )
        ],
      ),
    );
  }

  Padding getPrioritySelector() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          child: DropdownButton(
            value: _priority,
            elevation: 24,
            iconSize: 24,
            underline: Container(
              height: 2,
              // color: kMainComponentColor,
            ),
            onChanged: (value) {
              setState(() {
                _priority = value;
              });
            },
            icon: Icon(Icons.arrow_downward),
            items: <String>['Низкий', 'Средний', 'Большой']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Row getFrequencyInput() {
    return Row(
      children: [
        Text(
          'Повторять ',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(
          width: 30,
          child: TextFormField(
            initialValue: widget.isEditing ? habit.frequency.toString() : '',
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                _frequency = int.parse(value);
              });
            },
            validator: (val) {
              if (val == null || val.isEmpty || val == '0') {
                return '';
              }
              return null;
            },
            decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide()),
                labelStyle: TextStyle(color: Colors.black38),
                // fillColor: kMainComponentColor,
                // hoverColor: kMainComponentColor,
                // focusColor: kMainComponentColor,
                floatingLabelBehavior: FloatingLabelBehavior.never),
          ),
        ),
        Text(' раз в ', style: TextStyle(fontSize: 16)),
        SizedBox(
          width: 30,
          child: TextFormField(
            initialValue: widget.isEditing ? habit.period.toString() : '',
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                _period = int.parse(value);
              });
            },
            validator: (val) {
              if (val == null || val.isEmpty || val == '0') {
                return '';
              }
              return null;
            },
            decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(),
                ),
                labelStyle: TextStyle(color: Colors.black38),
                floatingLabelBehavior: FloatingLabelBehavior.never),
          ),
        ),
        Text('дней', style: TextStyle(fontSize: 16))
      ],
    );
  }
}
