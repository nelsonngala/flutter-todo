import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:hive_with_bloc/screens/update_todo_screen.dart';
import 'package:intl/intl.dart';

import '../logic/bloc/task_bloc.dart';

class CompletedTodos extends StatelessWidget {
  const CompletedTodos({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1d3557),
        title: const Text('Completed todos'),
        actions: [
          IconButton(
              onPressed: () {
                BlocProvider.of<TaskBloc>(context).add(ClearCompletedEvent());
              },
              icon: const Icon(Icons.delete))
        ],
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskAvailable) {
            var completedTask =
                state.taskModel.where((element) => element.isCompleted == true);
            if (completedTask.isEmpty) {
              return const Center(
                child: Text('No todo completed.'),
              );
            } else {
              return ListView(
                children: [
                  ...completedTask.map((e) => Card(
                        color: const Color(0xFF457b9d),
                        child: Dismissible(
                          key: UniqueKey(),
                          direction: DismissDirection.horizontal,
                          onDismissed: (direction) {
                            BlocProvider.of<TaskBloc>(context)
                                .add(DeleteTaskEvent(id: e.id));
                          },
                          child: ListTile(
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
                                ? 'Today'
                                : e.createdAt.isTomorrow
                                    ? 'Tomorrow'
                                    : DateFormat('E, d MMM yyyy')
                                        .format(e.createdAt)),
                            trailing: Checkbox(
                                value: e.isCompleted,
                                onChanged: (value) {
                                  Future.delayed(const Duration(seconds: 1),
                                      (() {
                                    BlocProvider.of<TaskBloc>(context)
                                        .add(ToggleEvent(taskModel: e));
                                  }));
                                }),
                          ),
                        ),
                      ))
                ],
              );
            }
          }
          if (state is TaskInitial) {
            return const Center(
              child: Text('No todo completed.'),
            );
          }
          return Container();
        },
      ),
    );
  }
}
