part of 'task_bloc.dart';

abstract class TaskState extends Equatable {
  const TaskState();
}

class TaskInitial extends TaskState {
  @override
  List<Object?> get props => [];
}

class TaskAvailable extends TaskState {
  final List<TaskModel> taskModel;

  const TaskAvailable({required this.taskModel});

  @override
  List<Object?> get props => [taskModel];
}
