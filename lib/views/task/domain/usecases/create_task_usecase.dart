import 'package:equatable/equatable.dart';
import '../../../../shared/models/task_model.dart';
import '../repositories/task_repository.dart';

class CreateTaskUseCase {
  final TaskRepository repository;

  CreateTaskUseCase(this.repository);

  Future<TaskModel> call(CreateTaskParams params) async {
    return await repository.createTask(params.task);
  }
}

class CreateTaskParams extends Equatable {
  final TaskModel task;

  const CreateTaskParams({required this.task});

  @override
  List<Object> get props => [task];
}
