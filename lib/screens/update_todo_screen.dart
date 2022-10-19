import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:hive_with_bloc/data/model/task_model.dart';
import 'package:hive_with_bloc/logic/bloc/task_bloc.dart';

class UpdateTodoScreen extends StatefulWidget {
  final String id;
  final String todo;
  final DateTime createdAt;
  final bool isCompleted;
  const UpdateTodoScreen({
    Key? key,
    required this.id,
    required this.todo,
    required this.createdAt,
    required this.isCompleted,
  }) : super(key: key);

  @override
  State<UpdateTodoScreen> createState() => _UpdateTodoScreenState();
}

class _UpdateTodoScreenState extends State<UpdateTodoScreen> {
  late TextEditingController _controller;
  late TextEditingController _dateController;
  late DateTime _updatedDate = widget.createdAt;

  Future<DateTime?> _showDatePicker() async {
    DateTime? dateTime = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    return dateTime;
  }

  @override
  void initState() {
    _controller = TextEditingController(text: widget.todo);
    _dateController = TextEditingController(
        text: widget.createdAt.isToday
            ? 'Today'
            : widget.createdAt.isTomorrow
                ? 'Tomorrow'
                : DateFormat('E, d MMM yyyy').format(widget.createdAt));
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
              id: widget.id,
              note: _controller.text.trim(),
              isCompleted: widget.isCompleted);
          BlocProvider.of<TaskBloc>(context)
              .add(UpdateTaskEvent(taskModel: taskModel));
          Navigator.of(context).pop();
        },
        child: const Icon(Icons.done_outline_outlined),
      ),
      appBar: AppBar(),
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
                      _updatedDate = updatedDate;
                    });
                  }
                  // _updatedDate = widget.createdAt;
                },
              ))
        ],
      ),
    );
  }
}

// int calculateDifference(DateTime date) {
//   DateTime now = DateTime.now();
//   return DateTime(date.year, date.month, date.day)
//       .difference(DateTime(now.year, now.month, now.day))
//       .inDays;
// }

//late int days;
//int isWhen = calculateDifference(DateTime.now());
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
