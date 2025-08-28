import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../shared/models/task_model.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/usecases/get_tasks_usecase.dart';
import '../../domain/usecases/create_task_usecase.dart';
import '../../domain/usecases/update_task_usecase.dart';
import '../../domain/usecases/delete_task_usecase.dart';
import '../../domain/usecases/toggle_task_status_usecase.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetTasksUseCase getTasksUseCase;
  final CreateTaskUseCase createTaskUseCase;
  final UpdateTaskUseCase updateTaskUseCase;
  final DeleteTaskUseCase deleteTaskUseCase;
  final ToggleTaskStatusUseCase toggleTaskStatusUseCase;

  TaskBloc({
    required this.getTasksUseCase,
    required this.createTaskUseCase,
    required this.updateTaskUseCase,
    required this.deleteTaskUseCase,
    required this.toggleTaskStatusUseCase,
  }) : super(TaskInitial()) {
    on<LoadTasks>(_onLoadTasks);
    on<CreateTask>(_onCreateTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
    on<ToggleTaskStatus>(_onToggleTaskStatus);
  }

  Future<void> _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      final tasks = await getTasksUseCase(GetTasksParams(userId: event.userId));
      emit(TaskLoaded(tasks));
    } on Failure catch (failure) {
      emit(TaskError(failure.message));
    }
  }

  Future<void> _onCreateTask(CreateTask event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      await createTaskUseCase(CreateTaskParams(task: event.task));
      emit(TaskSuccess('Task created successfully!'));
    } on Failure catch (failure) {
      emit(TaskError(failure.message));
    }
  }

  Future<void> _onUpdateTask(UpdateTask event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      await updateTaskUseCase(UpdateTaskParams(task: event.task));
      emit(TaskSuccess('Task updated successfully!'));
    } on Failure catch (failure) {
      emit(TaskError(failure.message));
    }
  }

  Future<void> _onDeleteTask(DeleteTask event, Emitter<TaskState> emit) async {
    final currentState = state;
    if (currentState is TaskLoaded) {
      // Optimistically update the UI first
      final updatedTasks = currentState.tasks.where((task) => task.id != event.taskId).toList();
      emit(TaskLoaded(updatedTasks));
      
      // Then delete from Firestore
      try {
        await deleteTaskUseCase(DeleteTaskParams(taskId: event.taskId));
        emit(TaskSuccess('Task deleted successfully!'));
      } on Failure catch (failure) {
        // Revert to original state if Firestore delete fails
        emit(TaskLoaded(currentState.tasks));
        emit(TaskError(failure.message));
      }
    }
  }

  Future<void> _onToggleTaskStatus(ToggleTaskStatus event, Emitter<TaskState> emit) async {
    final currentState = state;
    if (currentState is TaskLoaded) {
      // Optimistically update the UI first
      final updatedTasks = currentState.tasks.map((task) {
        if (task.id == event.taskId) {
          return task.copyWith(
            status: event.isCompleted ? TaskStatus.completed : TaskStatus.pending,
            updatedAt: DateTime.now(),
          );
        }
        return task;
      }).toList();
      emit(TaskLoaded(updatedTasks));
      
      // Then update in Firestore
      try {
        await toggleTaskStatusUseCase(ToggleTaskStatusParams(
          taskId: event.taskId,
          isCompleted: event.isCompleted,
        ));
        emit(TaskSuccess('Task status updated successfully!'));
      } on Failure catch (failure) {
        // Revert to original state if Firestore update fails
        emit(TaskLoaded(currentState.tasks));
        emit(TaskError(failure.message));
      }
    }
  }
}
