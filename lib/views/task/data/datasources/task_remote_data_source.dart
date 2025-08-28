import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../shared/models/task_model.dart';
import '../../../../core/errors/failures.dart';

abstract class TaskRemoteDataSource {
  Future<List<TaskModel>> getTasks(String userId);
  Future<TaskModel> createTask(TaskModel task);
  Future<TaskModel> updateTask(TaskModel task);
  Future<void> deleteTask(String taskId);
  Future<void> toggleTaskStatus(String taskId, bool isCompleted);
  Stream<List<TaskModel>> getTasksStream(String userId);
}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final FirebaseFirestore _firestore;

  TaskRemoteDataSourceImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<TaskModel>> getTasks(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('tasks')
          .where('userId', isEqualTo: userId)
          .get();

      final tasks = querySnapshot.docs
          .map((doc) => TaskModel.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
      
      // Sort by due date in memory
      tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
      
      return tasks;
    } catch (e) {
      throw const ServerFailure('Failed to fetch tasks');
    }
  }

  @override
  Future<TaskModel> createTask(TaskModel task) async {
    try {
      final docRef = await _firestore.collection('tasks').add(task.toMap());
      return task.copyWith(id: docRef.id);
    } catch (e) {
      throw const ServerFailure('Failed to create task');
    }
  }

  @override
  Future<TaskModel> updateTask(TaskModel task) async {
    try {
      await _firestore
          .collection('tasks')
          .doc(task.id)
          .update(task.toMap());
      return task;
    } catch (e) {
      throw const ServerFailure('Failed to update task');
    }
  }

  @override
  Future<void> deleteTask(String taskId) async {
    try {
      await _firestore.collection('tasks').doc(taskId).delete();
    } catch (e) {
      throw const ServerFailure('Failed to delete task');
    }
  }

  @override
  Future<void> toggleTaskStatus(String taskId, bool isCompleted) async {
    try {
      await _firestore.collection('tasks').doc(taskId).update({
        'status': isCompleted ? 'completed' : 'pending',
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      });
    } catch (e) {
      throw const ServerFailure('Failed to update task status');
    }
  }

  @override
  Stream<List<TaskModel>> getTasksStream(String userId) {
    return _firestore
        .collection('tasks')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          final tasks = snapshot.docs
              .map((doc) => TaskModel.fromMap({...doc.data(), 'id': doc.id}))
              .toList();
          
          // Sort by due date in memory
          tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
          
          return tasks;
        });
  }
}
