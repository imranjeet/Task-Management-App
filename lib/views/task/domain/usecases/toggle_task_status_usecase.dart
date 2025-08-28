import 'package:equatable/equatable.dart';
import '../repositories/task_repository.dart';

class ToggleTaskStatusUseCase {
  final TaskRepository repository;

  ToggleTaskStatusUseCase(this.repository);

  Future<void> call(ToggleTaskStatusParams params) async {
    return await repository.toggleTaskStatus(params.taskId, params.isCompleted);
  }
}

class ToggleTaskStatusParams extends Equatable {
  final String taskId;
  final bool isCompleted;

  const ToggleTaskStatusParams({
    required this.taskId,
    required this.isCompleted,
  });

  @override
  List<Object> get props => [taskId, isCompleted];
}
