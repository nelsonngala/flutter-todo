import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_with_bloc/screens/update_todo_screen.dart';
import 'package:intl/intl.dart';

import '../data/model/task_model.dart';
import '../logic/bloc/task_bloc.dart';

class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen({super.key});

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  late TextEditingController _dateController;
  final TextEditingController _controller = TextEditingController();
  late TextEditingController _timeController;

  late DateTime now = DateTime.now();
  //late DateTime sortTime;
  DateTime rightNow = DateTime.now();
  late DateTime time = DateTime(rightNow.year, rightNow.month, 0, 0, 0, 0);
  Future<DateTime?> _showDatePicker() async {
    DateTime? dateTime = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    return dateTime;
  }

  Future<DateTime?> showtimePicker() async {
    // DateTime? newTime = await _showDatePicker();
    TimeOfDay? selectedTime =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    DateTime timeTodo = DateTime(
        now.year,
        now.month,
        now.day,
        selectedTime!.hour,
        selectedTime.minute,
        now.millisecond,
        now.microsecond);
    return timeTodo;
  }

  @override
  void initState() {
    _dateController = TextEditingController(
        text: now.isToday
            ? 'Today'
            : now.isTomorrow
                ? 'Tomorrow'
                : DateFormat('E, d MMM yyyy').format(now));
    _timeController =
        TextEditingController(text: DateFormat('h:mm a').format(time));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //  DateTime newTime = now;
    // DateTime exactTime = time;
    const SnackBar snackBar =
        SnackBar(content: Text('what todo cannot be empty'));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add todo'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_controller.text.trim().isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(snackBar);

            return;
          }
          TaskModel taskModel = TaskModel.create(
              note: _controller.text.trim(), dateTime: now, timeOfDay: time);
          BlocProvider.of<TaskBloc>(context).add(AddTaskEvent(taskModel));
          Navigator.of(context).pop();
        },
        child: const Icon(Icons.done),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 5.0,
          ),
          const Text('What are you going to todo?'),
          const SizedBox(
            height: 5.0,
          ),
          Container(
              margin: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: TextField(
                controller: _controller,
              )),
          const SizedBox(
            height: 5.0,
          ),
          const Text('When to todo?'),
          const SizedBox(
            height: 5.0,
          ),
          Container(
              margin: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: TextField(
                controller: _dateController,
                readOnly: true,
                decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.calendar_month_rounded)),
                onTap: () async {
                  DateTime? updatedDate = await _showDatePicker();
                  if (updatedDate != null) {
                    setState(() {
                      _dateController = TextEditingController(
                          text: updatedDate.isToday
                              ? 'Today'
                              : updatedDate.isTomorrow
                                  ? 'Tomorrow'
                                  : DateFormat('E, d MMM yyyy')
                                      .format(updatedDate));
                      // _updatedDate = updatedDate;
                    });
                    setState(() {
                      now = updatedDate;
                    });
                    // setState(() {
                    //   time = updatedDate;
                    // });
                    //  sortTime = updatedDate;
                  }
                  //   now = updatedDate!;
                  // _updatedDate = widget.createdAt;
                },
              )),
          const SizedBox(
            height: 5,
          ),
          Container(
              margin: const EdgeInsets.only(left: 10.0, right: 50.0),
              child: TextField(
                readOnly: true,
                controller: _timeController,
                decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.watch_later_outlined)),
                onTap: () async {
                  DateTime? timeOfDay = await showtimePicker();
                  if (timeOfDay != null) {
                    setState(() {
                      // DateTime timeToAdd = DateTime(now.year, now.month,
                      //     now.day, timeOfDay.hour, timeOfDay.minute);
                      time = timeOfDay;
                      // now = timeOfDay;
                    });
                    setState(() {
                      now = timeOfDay;
                    });
                    setState(() {
                      _timeController = TextEditingController(
                          text: DateFormat('h:mm a').format(timeOfDay));
                    });
                  }
                  // setState(() {
                  //   now = time;
                  // });
                  //  else {
                  //   setState(() {
                  //     time = DateTime(now.year, now.month, now.day,
                  //         rightNow.hour, rightNow.minute);
                  //   });
                  // }
                },
              ))
        ],
      ),
    );
  }
}


  // onPressed: () {
  //               TaskModel taskModel = TaskModel.create(
  //                 note: _controller.text,
  //                 dateTime: _dateTime,
  //               );
  //               BlocProvider.of<TaskBloc>(context).add(AddTaskEvent(taskModel));
  //               Navigator.of(context).pop();
  //             },