import '../../../../shared/models/task_model.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_remote_data_source.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource remoteDataSource;

  TaskRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<TaskModel>> getTasks(String userId) async {
    try {
      return await remoteDataSource.getTasks(userId);
    } on Failure {
      rethrow;
    } catch (e) {
      throw const ServerFailure('Failed to fetch tasks');
    }
  }

  @override
  Future<TaskModel> createTask(TaskModel task) async {
    try {
      return await remoteDataSource.createTask(task);
    } on Failure {
      rethrow;
    } catch (e) {
      throw const ServerFailure('Failed to create task');
    }
  }

  @override
  Future<TaskModel> updateTask(TaskModel task) async {
    try {
      return await remoteDataSource.updateTask(task);
    } on Failure {
      rethrow;
    } catch (e) {
      throw const ServerFailure('Failed to update task');
    }
  }

  @override
  Future<void> deleteTask(String taskId) async {
    try {
      await remoteDataSource.deleteTask(taskId);
    } on Failure {
      rethrow;
    } catch (e) {
      throw const ServerFailure('Failed to delete task');
    }
  }

  @override
  Future<void> toggleTaskStatus(String taskId, bool isCompleted) async {
    try {
      await remoteDataSource.toggleTaskStatus(taskId, isCompleted);
    } on Failure {
      rethrow;
    } catch (e) {
      throw const ServerFailure('Failed to update task status');
    }
  }

  @override
  Stream<List<TaskModel>> getTasksStream(String userId) {
    return remoteDataSource.getTasksStream(userId);
  }
}
