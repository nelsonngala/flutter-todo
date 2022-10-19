import 'package:hive/hive.dart';
import 'package:hive_with_bloc/data/model/task_model.dart';

class HiveStorage {
  //Hive.box<TaskModel>('Tasks');

  Future<Box<TaskModel>> init() async {
    // Hive.registerAdapter(TaskModelAdapter());
    Box<TaskModel> box = await Hive.openBox<TaskModel>('Tasks');
    return box;
  }

  Future<List<TaskModel>>? getTasks() async {
    final box = await init();
    List<TaskModel> taskModel = box.values.toList();
    taskModel.sort(((a, b) => a.createdAt.compareTo(b.createdAt)));
    return taskModel; //.values.toList();
  }

  Future<void> addTask(TaskModel taskModel) async {
    var box = await init();

    await box.put(taskModel.id, taskModel);
  }

  Future<void> updateTask(TaskModel taskModel) async {
    var box = await init();

    await box.put(taskModel.id, taskModel);
  }

  Future<void> toggleTask(TaskModel taskModel) async {
    var box = await init();

    await box.put(
        taskModel.id,
        TaskModel(
            id: taskModel.id,
            note: taskModel.note,
            createdAt: taskModel.createdAt,
            isCompleted: !taskModel.isCompleted));
  }
  //TaskModel? taskModel;

  Future<void> deleteTask(String id) async {
    var box = await init();

    return box.delete(id);
  }

  Future<void> clearCompleted() async {
    var box = await init();
    var completedTasks =
        box.values.where((element) => element.isCompleted == true).toList();
    var completedTasksKeys = completedTasks.map((e) => e.id).toList();
    box.deleteAll(completedTasksKeys);
  }
}
