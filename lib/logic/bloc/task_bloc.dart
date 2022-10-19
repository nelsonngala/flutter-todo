//import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_with_bloc/data/hive_storage.dart';

import '../../data/model/task_model.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final HiveStorage _hiveStorage;
  TaskBloc(this._hiveStorage) : super(TaskInitial()) {
    on<GetTaskEvent>((event, emit) async {
      List<TaskModel>? tasks = await _hiveStorage.getTasks();
      //tasks.sort((a, b) => a.createdAt.compareTo(b.createdAt));

      if (tasks!.isEmpty) {
        emit(TaskInitial());
      } else {
        emit(TaskAvailable(taskModel: tasks));
      }
    });
    on<AddTaskEvent>((event, emit) async {
      await _hiveStorage.addTask(event._taskModel);
      add(GetTaskEvent());
    });
    on<UpdateTaskEvent>((event, emit) async {
      await _hiveStorage.updateTask(
        event.taskModel,
      );
      // emit(TaskUpdated(id: event.id, taskModel: event.taskModel));
      add(GetTaskEvent());
    });
    on<DeleteTaskEvent>((event, emit) async {
      await _hiveStorage.deleteTask(event.id);

      add(GetTaskEvent());
    });
    on<ToggleEvent>((event, emit) async {
      await _hiveStorage.toggleTask(event.taskModel);

      add(GetTaskEvent());
    });

    on<ClearCompletedEvent>((event, emit) async {
      await _hiveStorage.clearCompleted();
      emit(TaskInitial());
      add(GetTaskEvent());
    });
  }
}
