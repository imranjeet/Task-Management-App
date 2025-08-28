import 'package:equatable/equatable.dart';
import '../../../../shared/models/task_model.dart';
import '../repositories/task_repository.dart';

class GetTasksUseCase {
  final TaskRepository repository;

  GetTasksUseCase(this.repository);

  Future<List<TaskModel>> call(GetTasksParams params) async {
    return await repository.getTasks(params.userId);
  }
}

class GetTasksParams extends Equatable {
  final String userId;

  const GetTasksParams({required this.userId});

  @override
  List<Object> get props => [userId];
}
