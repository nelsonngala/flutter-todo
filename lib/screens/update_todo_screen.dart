import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_with_bloc/screens/notifications/local_notifications.dart';
import 'package:intl/intl.dart';

import 'package:hive_with_bloc/data/model/task_model.dart';
import 'package:hive_with_bloc/logic/bloc/task_bloc.dart';

class UpdateTodoScreen extends StatefulWidget {
  final String id;
  final String todo;
  final DateTime createdAt;
  final DateTime timeOfDoing;
  final bool isCompleted;
  const UpdateTodoScreen({
    Key? key,
    required this.id,
    required this.todo,
    required this.createdAt,
    required this.timeOfDoing,
    required this.isCompleted,
  }) : super(key: key);

  @override
  State<UpdateTodoScreen> createState() => _UpdateTodoScreenState();
}

class _UpdateTodoScreenState extends State<UpdateTodoScreen> {
  late TextEditingController _controller;
  late TextEditingController _dateController;
  late TextEditingController _timeController;
  late DateTime _updatedDate = widget.createdAt;
  late DateTime _timeOfDay = widget.timeOfDoing;
  late LocalNotifications _notifications;

  @override
  void initState() {
    _controller = TextEditingController(text: widget.todo);
    _dateController = TextEditingController(
        text: widget.createdAt.isToday
            ? 'Today'
            : widget.createdAt.isTomorrow
                ? 'Tomorrow'
                : DateFormat('E, d MMM yyyy').format(widget.createdAt));
    _timeController = TextEditingController(
        text: DateFormat('hh:mm a').format(widget.timeOfDoing));

    //implementing local notification
    _notifications = LocalNotifications(context);
    _notifications.initialize();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<DateTime?> showdatePicker() async {
      DateTime? dateTime = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100));
      return dateTime;
    }

    Future<DateTime?> showtimePicker(BuildContext context) async {
      // DateTime now = DateTime.now();
      TimeOfDay? selectedTime =
          await showTimePicker(context: context, initialTime: TimeOfDay.now());
      DateTime timeTodo = DateTime(
        _updatedDate.year,
        _updatedDate.month,
        _updatedDate.day,
        selectedTime!.hour,
        selectedTime.minute,
      );
      return timeTodo;
    }

    const SnackBar snackBar =
        SnackBar(content: Text('what todo cannot be empty'));
    //  late DateTime _updatedDate = widget.createdAt;
    //    late TextEditingController _controller;
    // late TextEditingController _dateController;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_controller.text.trim().isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            return;
          }
          TaskModel taskModel = TaskModel(
              createdAt: _updatedDate,
              timeOfDay: _timeOfDay,
              id: widget.id,
              note: _controller.text.trim(),
              isCompleted: widget.isCompleted);
          BlocProvider.of<TaskBloc>(context)
              .add(UpdateTaskEvent(taskModel: taskModel));
          Navigator.of(context).pop();
        },
        child: const Icon(Icons.done_outline_outlined),
      ),
      appBar: AppBar(
        title: const Text('Update todo'),
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
                  DateTime? updatedDate = await showdatePicker();
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
                      _updatedDate = updatedDate;
                    });
                    setState(() {
                      _timeController = TextEditingController(
                          text: DateFormat('hh:mm a').format(updatedDate));
                    });
                  }
                  return;
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
                  DateTime? timeOfDay = await showtimePicker(context);
                  if (timeOfDay != null) {
                    setState(() {
                      _timeOfDay = timeOfDay;
                    });
                    setState(() {
                      _updatedDate = timeOfDay;
                    });
                    setState(() {
                      _timeController = TextEditingController(
                          text: DateFormat('hh:mm a').format(timeOfDay));
                    });
                  }
                },
              )),
          ElevatedButton(
              onPressed: () {
                _notifications.showNotification(
                    id: _updatedDate.minute +
                        _updatedDate.day +
                        _updatedDate.second,
                    title: _controller.text,
                    body: _timeController.text,
                    dateTime: _updatedDate);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('You will be notified in due time!')));
              },
              child: const Text('Notify me?'))
        ],
      ),
    );
  }
}

extension DateUtils on DateTime {
  bool get isToday {
    final now = DateTime.now();
    return now.day == day && now.month == month && now.year == year;
  }

  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return tomorrow.day == day &&
        tomorrow.month == month &&
        tomorrow.year == year;
  }

  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return yesterday.day == day &&
        yesterday.month == month &&
        yesterday.year == year;
  }

  // bool get isWithinAweek {
  //   final yesterday = DateTime.now().subtract(const Duration(days: 1));
  //   return yesterday.day == day &&
  //       yesterday.month == month &&
  //       yesterday.year == year;
  // }
}
