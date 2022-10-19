part of 'task_bloc.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();
}

class GetTaskEvent extends TaskEvent {
  @override
  List<Object?> get props => [];
}

class AddTaskEvent extends TaskEvent {
  final TaskModel _taskModel;

  const AddTaskEvent(this._taskModel);

  @override
  List<Object> get props => [_taskModel];
}

class UpdateTaskEvent extends TaskEvent {
  final TaskModel taskModel;

  const UpdateTaskEvent({required this.taskModel});

  @override
  List<Object?> get props => [taskModel];
}

class DeleteTaskEvent extends TaskEvent {
  final String id;
  const DeleteTaskEvent({
    required this.id,
  });

  @override
  List<Object?> get props => [id];
}

class ToggleEvent extends TaskEvent {
  final TaskModel taskModel;

  const ToggleEvent({required this.taskModel});
  @override
  List<Object?> get props => [taskModel];
}

class ClearCompletedEvent extends TaskEvent {
  @override
  List<Object?> get props => throw UnimplementedError();
}
