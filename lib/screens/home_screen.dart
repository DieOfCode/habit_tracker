import 'package:final_tracker/blocs/blocs.dart';
import 'package:final_tracker/models/models.dart';
import 'package:final_tracker/widgets/filtered_habits.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Simple habit tracker'),
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text('Хорошие'),
              ),
              Tab(
                child: Text('Плохие'),
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            FilteredHabits(
              type: 'good',
            ),
            FilteredHabits(type: 'bad')
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/create_habit');
          },
          child: Icon(Icons.add),
        ),
        bottomNavigationBar: TrackerNavigationBar(),
      ),
    );
  }
}

// enum SortingType { up, down, none }

class TrackerNavigationBar extends StatefulWidget {
  @override
  _TrackerNavigationBarState createState() => _TrackerNavigationBarState();
}

class _TrackerNavigationBarState extends State<TrackerNavigationBar> {
  final TextEditingController textController = new TextEditingController();
  VisibilityFilter _value = VisibilityFilter.down;

  @override
  Widget build(BuildContext context) {
    final provider = BlocProvider.of<FilteredHabitsBloc>(context);
    return BlocBuilder<FilteredHabitsBloc, FilteredHabitsState>(
      builder: (context, blocState) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black38),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                  BlocProvider.of<HabitsBloc>(context).add(HabitsLoaded());
                },
              ),
              IconButton(
                icon: Icon(Icons.list),
                onPressed: () {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(15.0)),
                    ),
                    context: context,
                    builder: (context) {
                      textController.clear();
                      return BlocProvider.value(
                        value: provider,
                        child: StatefulBuilder(
                          builder: (context, state) => DraggableScrollableSheet(
                            expand: false,
                            builder: (BuildContext context,
                                ScrollController scrollController) {
                              return SingleChildScrollView(
                                child: Container(
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Row(
                                          children: <Widget>[
                                            Flexible(
                                              child: TextField(
                                                controller: textController,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.all(8),
                                                  border:
                                                      new OutlineInputBorder(
                                                    borderRadius:
                                                        new BorderRadius
                                                            .circular(15.0),
                                                    borderSide:
                                                        new BorderSide(),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.search),
                                              color: Color(0xFF1F91E7),
                                              onPressed: () {
                                                context
                                                    .read<FilteredHabitsBloc>()
                                                    .add(FilterUpdated(_value,
                                                        textController.text));
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        children: <Widget>[
                                          ListTile(
                                            title: const Text('По возрастанию'),
                                            leading: Radio(
                                              value: VisibilityFilter.up,
                                              groupValue: _value,
                                              onChanged:
                                                  (VisibilityFilter value) {
                                                state(() {
                                                  _value = value;
                                                });
                                              },
                                            ),
                                          ),
                                          ListTile(
                                            title: const Text('По убыванию'),
                                            leading: Radio(
                                              value: VisibilityFilter.down,
                                              groupValue: _value,
                                              onChanged:
                                                  (VisibilityFilter value) {
                                                state(
                                                  () {
                                                    _value = value;
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              )
            ],
          ),
        );
      },
    );
  }
}
