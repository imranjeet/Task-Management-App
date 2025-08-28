import 'package:equatable/equatable.dart';
import '../repositories/task_repository.dart';

class DeleteTaskUseCase {
  final TaskRepository repository;

  DeleteTaskUseCase(this.repository);

  Future<void> call(DeleteTaskParams params) async {
    return await repository.deleteTask(params.taskId);
  }
}

class DeleteTaskParams extends Equatable {
  final String taskId;

  const DeleteTaskParams({required this.taskId});

  @override
  List<Object> get props => [taskId];
}
