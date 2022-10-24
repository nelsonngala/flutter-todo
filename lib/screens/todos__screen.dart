import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_with_bloc/screens/completed_todos.dart';
import 'package:intl/intl.dart';

import 'package:hive_with_bloc/data/model/task_model.dart';
import 'package:hive_with_bloc/logic/bloc/task_bloc.dart';
import 'package:hive_with_bloc/screens/add_todo.dart';
import 'package:hive_with_bloc/screens/update_todo_screen.dart';

class TodosScreen extends StatelessWidget {
  const TodosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFa8dadc),
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: ((context) => const CompletedTodos())));
              },
              icon: const Icon(Icons.done_outline_outlined))
        ],
        backgroundColor: const Color(0xFF1d3557),
        title: const Text('What would you like to do?'),
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: const Color(0xFF1d3557),
        backgroundColor: Colors.deepPurple,
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: ((context) => const AddTodoScreen())));
        },
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskAvailable) {
            return TasksLoaded(tasks: state.taskModel);
          }
          if (state is TaskInitial) {
            return const Center(
              child: Text('You have nothing to be done.'),
            );
          }
          return Container();
        },
      ),
    );
  }
}

class TasksLoaded extends StatelessWidget {
  final List<TaskModel> tasks;
  const TasksLoaded({
    Key? key,
    required this.tasks,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var incompletedTask = tasks.where((el) => el.isCompleted == false).toList();
    if (incompletedTask.isEmpty) {
      return const Center(
        child: Text('Nothing todo yet.'),
      );
    }
    return ListView.builder(
        itemCount: incompletedTask.length,
        itemBuilder: ((context, index) {
          TaskModel e = incompletedTask[index];
          return Card(
            color: const Color(0xFF457b9d),
            child: Dismissible(
              key: UniqueKey(),
              direction: DismissDirection.horizontal,
              onDismissed: (direction) {
                BlocProvider.of<TaskBloc>(context)
                    .add(DeleteTaskEvent(id: e.id));
              },
              child: ListTile(
                //  isThreeLine: true,
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => UpdateTodoScreen(
                            todo: e.note,
                            createdAt: e.createdAt,
                            timeOfDoing: e.timeOfDay,
                            id: e.id,
                            isCompleted: e.isCompleted,
                          ))));
                },
                title: Text(
                  e.note,
                  style: TextStyle(
                      decoration: e.isCompleted == true
                          ? TextDecoration.lineThrough
                          : TextDecoration.none),
                ),
                subtitle: Text(e.createdAt.isToday
                    ? 'Today, ${DateFormat('h:mm a').format(e.createdAt)}'
                    : e.createdAt.isTomorrow
                        ? 'Tomorrow, ${DateFormat('h:mm a').format(e.createdAt)}'
                        : e.createdAt.isYesterday
                            ? 'yesterday, ${DateFormat('h:mm a').format(e.createdAt)}'
                            : DateFormat('E MMM d, yyyy. h:mm a')
                                .format(e.createdAt)),
                //   '${DateFormat('E, d MMM yyyy').format(e.createdAt)}, ${DateFormat('h:mm a').format(e.timeOfDay)}'),
                trailing: Transform.scale(
                  scale: 1.5,
                  child: Checkbox(
                      shape: const CircleBorder(),
                      value: e.isCompleted,
                      onChanged: (value) {
                        // BlocProvider.of<TaskBloc>(context)
                        //    .add(ToggleEvent(taskModel: e));
                        Future.delayed(const Duration(seconds: 1), (() {
                          BlocProvider.of<TaskBloc>(context)
                              .add(ToggleEvent(taskModel: e));
                        }));
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('task completed')));
                      }),
                ),
              ),
            ),
          );
        }));
  }
}
