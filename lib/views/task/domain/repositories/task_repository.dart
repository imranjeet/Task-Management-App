import '../../../../shared/models/task_model.dart';

abstract class TaskRepository {
  Future<List<TaskModel>> getTasks(String userId);
  Future<TaskModel> createTask(TaskModel task);
  Future<TaskModel> updateTask(TaskModel task);
  Future<void> deleteTask(String taskId);
  Future<void> toggleTaskStatus(String taskId, bool isCompleted);
  Stream<List<TaskModel>> getTasksStream(String userId);
}
