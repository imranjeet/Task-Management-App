part of 'task_bloc.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class LoadTasks extends TaskEvent {
  final String userId;

  const LoadTasks({required this.userId});

  @override
  List<Object> get props => [userId];
}

class CreateTask extends TaskEvent {
  final TaskModel task;

  const CreateTask({required this.task});

  @override
  List<Object> get props => [task];
}

class UpdateTask extends TaskEvent {
  final TaskModel task;

  const UpdateTask({required this.task});

  @override
  List<Object> get props => [task];
}

class DeleteTask extends TaskEvent {
  final String taskId;

  const DeleteTask({required this.taskId});

  @override
  List<Object> get props => [taskId];
}

class ToggleTaskStatus extends TaskEvent {
  final String taskId;
  final bool isCompleted;

  const ToggleTaskStatus({
    required this.taskId,
    required this.isCompleted,
  });

  @override
  List<Object> get props => [taskId, isCompleted];
}
