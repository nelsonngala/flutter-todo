import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'task_model.g.dart';

@HiveType(typeId: 1)
class TaskModel extends HiveObject {
  // @HiveField(0)
  // final String id;
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String note;
  @HiveField(2)
  final DateTime createdAt;
  @HiveField(3)
  bool isCompleted;
  @HiveField(4)
  final DateTime timeOfDay;

  TaskModel({
    // required this.id,
    required this.id,
    required this.note,
    required this.createdAt,
    required this.timeOfDay,
    required this.isCompleted,
  });

  factory TaskModel.create(
          {required String note,
          required DateTime? dateTime,
          required DateTime? timeOfDay}) =>
      TaskModel(
          id: const Uuid().v1(),
          note: note,
          createdAt: dateTime ?? DateTime.now(),
          timeOfDay: timeOfDay ?? DateTime.now(),
          isCompleted: false);
}
