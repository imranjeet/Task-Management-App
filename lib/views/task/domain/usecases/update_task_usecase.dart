import 'package:equatable/equatable.dart';
import '../../../../shared/models/task_model.dart';
import '../repositories/task_repository.dart';

class UpdateTaskUseCase {
  final TaskRepository repository;

  UpdateTaskUseCase(this.repository);

  Future<TaskModel> call(UpdateTaskParams params) async {
    return await repository.updateTask(params.task);
  }
}

class UpdateTaskParams extends Equatable {
  final TaskModel task;

  const UpdateTaskParams({required this.task});

  @override
  List<Object> get props => [task];
}
