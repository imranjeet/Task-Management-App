import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:task_management_app/views/task/presentation/pages/add_task_page.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/string_constants.dart';
import '../../../../shared/models/task_model.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../bloc/task_bloc.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  String? _currentUserId;
  TaskPriority? _selectedPriorityFilter;
  TaskStatus? _selectedStatusFilter;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentUserId = FirebaseAuth.instance.currentUser?.uid;
    context.read<TaskBloc>().add(LoadTasks(userId: _currentUserId!));
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    final formatter = DateFormat('EEEE, d MMM');
    return formatter.format(now);
  }

  List<TaskModel> _filterTasks(List<TaskModel> tasks) {
    List<TaskModel> filteredTasks = tasks;

    // Filter by search text
    if (_searchController.text.isNotEmpty) {
      filteredTasks = filteredTasks
          .where((task) =>
              task.title
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()) ||
              task.description
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()))
          .toList();
    }

    // Filter by priority
    if (_selectedPriorityFilter != null) {
      filteredTasks = filteredTasks
          .where((task) => task.priority == _selectedPriorityFilter)
          .toList();
    }

    // Filter by status
    if (_selectedStatusFilter != null) {
      filteredTasks = filteredTasks
          .where((task) => task.status == _selectedStatusFilter)
          .toList();
    }

    // Sort by due date (earliest to latest)
    filteredTasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));

    return filteredTasks;
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      StringConstants.filterTasks,
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1F2937),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedPriorityFilter = null;
                          _selectedStatusFilter = null;
                          _searchController.clear();
                        });
                        Navigator.pop(context);
                      },
                      child: Text(
                        StringConstants.clearAll,
                        style: GoogleFonts.poppins(
                          color: AppConstants.buttonColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Priority Filter Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      StringConstants.priorityFilter,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingSmall),
                    Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      children: [
                        FilterChip(
                          label: Text(StringConstants.statusAll),
                          selected: _selectedPriorityFilter == null,
                          selectedColor:
                              AppConstants.buttonColor.withValues(alpha: 0.2),
                          checkmarkColor: AppConstants.buttonColor,
                          onSelected: (selected) {
                            setState(() {
                              _selectedPriorityFilter = null;
                            });
                            Navigator.pop(context);
                          },
                        ),
                        ...TaskPriority.values.map((priority) {
                          String label;
                          Color color;
                          switch (priority) {
                            case TaskPriority.low:
                              label = StringConstants.priorityLow;
                              color = const Color(0xFF10B981);
                              break;
                            case TaskPriority.medium:
                              label = StringConstants.priorityMedium;
                              color = const Color(0xFFF59E0B);
                              break;
                            case TaskPriority.high:
                              label = StringConstants.priorityHigh;
                              color = const Color(0xFFEF4444);
                              break;
                          }
                          return FilterChip(
                            label: Text(label),
                            selected: _selectedPriorityFilter == priority,
                            selectedColor: color.withValues(alpha: 0.2),
                            checkmarkColor: color,
                            onSelected: (selected) {
                              setState(() {
                                _selectedPriorityFilter =
                                    selected ? priority : null;
                              });
                              Navigator.pop(context);
                            },
                          );
                        }),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppConstants.paddingLarge),

              // Status Filter Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      StringConstants.statusFilter,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingSmall),
                    Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      children: [
                        FilterChip(
                          label: Text(StringConstants.statusAll),
                          selected: _selectedStatusFilter == null,
                          selectedColor:
                              AppConstants.buttonColor.withValues(alpha: 0.2),
                          checkmarkColor: AppConstants.buttonColor,
                          onSelected: (selected) {
                            setState(() {
                              _selectedStatusFilter = null;
                            });
                            Navigator.pop(context);
                          },
                        ),
                        ...TaskStatus.values.map((status) {
                          String label;
                          Color color;
                          switch (status) {
                            case TaskStatus.pending:
                              label = StringConstants.statusPending;
                              color = const Color(0xFFF59E0B);
                              break;
                            case TaskStatus.completed:
                              label = StringConstants.statusCompleted;
                              color = const Color(0xFF10B981);
                              break;
                          }
                          return FilterChip(
                            label: Text(label),
                            selected: _selectedStatusFilter == status,
                            selectedColor: color.withValues(alpha: 0.2),
                            checkmarkColor: color,
                            onSelected: (selected) {
                              setState(() {
                                _selectedStatusFilter =
                                    selected ? status : null;
                              });
                              Navigator.pop(context);
                            },
                          );
                        }),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthInitial) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false,
                );
              }
            },
          ),
          BlocListener<TaskBloc, TaskState>(
            listener: (context, state) {
              if (state is TaskSuccess) {
                // Refresh tasks after successful operations
                if (_currentUserId != null) {
                  context
                      .read<TaskBloc>()
                      .add(LoadTasks(userId: _currentUserId!));
                }
              }
            },
          ),
        ],
        child: RefreshIndicator(
          onRefresh: () async {
            if (_currentUserId != null) {
              context.read<TaskBloc>().add(LoadTasks(userId: _currentUserId!));
            }
          },
          child: CustomScrollView(
            slivers: [
              // Custom SliverAppBar
              SliverAppBar(
                expandedHeight: 150,
                floating: true,
                pinned: true,
                backgroundColor: AppConstants.primaryColor,
                // backgroundColor: Colors.transparent,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppConstants.primaryColor,
                          AppConstants.secondaryColor
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 20,
                          left: 20,
                          right: 20,
                          bottom: 10,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Date and Title (will scroll up)
                            const Spacer(),
                            Text(
                              _getFormattedDate(),
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  StringConstants.myTasks,
                                  style: AppConstants.titleLargeStyle.copyWith(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: _showFilterDialog,
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Icon(
                                      Icons.filter_list,
                                      color: AppConstants.buttonColor,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // Pinned header items
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.grid_view_rounded,
                        color: Colors.white, size: 28),
                    Container(
                      height: 40,
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(35),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        child: TextField(
                          controller: _searchController,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 12,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: StringConstants.searchTasks,
                            hintStyle: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Colors.grey,
                              size: 20,
                            ),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(
                                      Icons.clear,
                                      color: Colors.grey,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() {});
                                    },
                                  )
                                : null,
                            border: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                          onChanged: (value) {
                            setState(() {});
                          },
                          onSubmitted: (value) {
                            // Hide keyboard when search is submitted
                            FocusScope.of(context).unfocus();
                          },
                        ),
                      ),
                    ),

                    // const SizedBox(width: 8),

                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_horiz,
                          color: Colors.white, size: 28),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onSelected: (value) async {
                        if (value == StringConstants.logoutValue) {
                          // Sign out from Firebase
                          context.read<AuthBloc>().add(SignOutRequested());
                        }
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(
                          value: StringConstants.logoutValue,
                          child: Row(
                            children: [
                              Icon(Icons.logout),
                              SizedBox(width: 8),
                              Text(StringConstants.logout),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Task list
              BlocBuilder<TaskBloc, TaskState>(
                builder: (context, state) {
                  if (state is TaskLoading) {
                    return const SliverToBoxAdapter(
                      child: Center(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                            SizedBox(height: 100),
                            CircularProgressIndicator()
                          ])),
                    );
                  } else if (state is TaskError) {
                    return SliverToBoxAdapter(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 100),
                            Icon(Icons.error_outline,
                                size: 64, color: AppConstants.errorColor),
                            const SizedBox(height: AppConstants.paddingMedium),
                            Text('Error: ${state.message}',
                                style: AppConstants.bodyStyle),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                if (_currentUserId != null) {
                                  context
                                      .read<TaskBloc>()
                                      .add(LoadTasks(userId: _currentUserId!));
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppConstants.buttonColor,
                                foregroundColor: Colors.white,
                              ),
                              child: Text(StringConstants.retry),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (state is TaskLoaded) {
                    final filteredTasks = _filterTasks(state.tasks);
                    if (filteredTasks.isEmpty) {
                      return SliverToBoxAdapter(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 100),
                              Icon(Icons.task_alt,
                                  size: 64, color: Colors.grey[400]),
                              const SizedBox(height: 16),
                              Text(
                                state.tasks.isEmpty
                                    ? StringConstants.noTasksYet
                                    : StringConstants.noTasksFound,
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                state.tasks.isEmpty
                                    ? StringConstants.createFirstTask
                                    : StringConstants.adjustSearchFilters,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return _buildTaskListSliver(filteredTasks);
                  }

                  // Show empty state
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.task_alt,
                              size: 64, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            StringConstants.noTasksYet,
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            StringConstants.createFirstTask,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddTaskPage(userId: _currentUserId!)),
          ).then((_) {
            // Refresh tasks when returning from add page
            if (_currentUserId != null) {
              // ignore: use_build_context_synchronously
              context.read<TaskBloc>().add(LoadTasks(userId: _currentUserId!));
            }
          });
        },
        child: Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppConstants.buttonColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppConstants.buttonColor.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Main plus icon
              const Icon(
                Icons.add,
                color: Colors.white,
                size: 28,
              ),
              // Small pencil icon overlay
              Positioned(
                bottom: 8,
                right: 8,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.edit,
                    color: AppConstants.buttonColor,
                    size: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        elevation: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.list, color: AppConstants.buttonColor),
            ),
            const SizedBox(width: 40),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.calendar_today,
                  color: AppConstants.buttonColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskListSliver(List<TaskModel> tasks) {
    final today = DateTime.now();
    final tomorrow = today.add(const Duration(days: 1));
    final thisWeek = today.add(const Duration(days: 7));

    final todayTasks = tasks
        .where((task) =>
            task.dueDate.day == today.day &&
            task.dueDate.month == today.month &&
            task.dueDate.year == today.year)
        .toList();

    final tomorrowTasks = tasks
        .where((task) =>
            task.dueDate.day == tomorrow.day &&
            task.dueDate.month == tomorrow.month &&
            task.dueDate.year == tomorrow.year)
        .toList();

    final thisWeekTasks = tasks
        .where((task) =>
            task.dueDate.isAfter(tomorrow) && task.dueDate.isBefore(thisWeek))
        .toList();

    return SliverPadding(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          if (todayTasks.isNotEmpty) ...[
            _buildSectionHeader(StringConstants.today),
            ...todayTasks.map((task) => _buildTaskCard(task)),
            const SizedBox(height: AppConstants.spacingSmall),
          ],
          if (tomorrowTasks.isNotEmpty) ...[
            _buildSectionHeader(StringConstants.tomorrow),
            ...tomorrowTasks.map((task) => _buildTaskCard(task)),
            const SizedBox(height: AppConstants.spacingSmall),
          ],
          if (thisWeekTasks.isNotEmpty) ...[
            _buildSectionHeader(StringConstants.thisWeek),
            ...thisWeekTasks.map((task) => _buildTaskCard(task)),
          ],
        ]),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 5),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF1F2937),
        ),
      ),
    );
  }

  Widget _buildTaskCard(TaskModel task) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => _handleDeleteTask(task),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: StringConstants.delete,
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 1,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            children: [
              // Checkbox
              GestureDetector(
                onTap: () => _toggleTaskStatus(task),
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: task.status == TaskStatus.completed
                          ? const Color(0xFF10B981)
                          : const Color(0xFFD1D5DB),
                      width: 2,
                    ),
                    color: task.status == TaskStatus.completed
                        ? const Color(0xFF10B981)
                        : Colors.transparent,
                  ),
                  child: task.status == TaskStatus.completed
                      ? const Icon(Icons.check, color: Colors.white, size: 16)
                      : null,
                ),
              ),

              const SizedBox(width: 12),

              // Task content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: task.status == TaskStatus.completed
                            ? const Color(0xFF9CA3AF)
                            : const Color(0xFF1F2937),
                        decoration: task.status == TaskStatus.completed
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('d MMM').format(task.dueDate),
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: task.status == TaskStatus.completed
                            ? const Color(0xFF9CA3AF)
                            : const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 5),

              // Tags and Actions
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Priority Tag
                  _buildPriorityTag(task.priority),
                  const SizedBox(width: 8),
                  // Edit Button
                  GestureDetector(
                    onTap: () => _editTask(task),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0xFF6366F1).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: Color(0xFF6366F1),
                        size: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityTag(TaskPriority priority) {
    String text;
    Color color;

    switch (priority) {
      case TaskPriority.low:
        text = StringConstants.priorityLow;
        color = const Color(0xFF10B981);
        break;
      case TaskPriority.medium:
        text = StringConstants.priorityMedium;
        color = const Color(0xFFF59E0B);
        break;
      case TaskPriority.high:
        text = StringConstants.priorityHigh;
        color = const Color(0xFFEF4444);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );
  }

  // Widget _buildTag(String text, Color color) {
  //   return Container(
  //     margin: const EdgeInsets.only(left: 4),
  //     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  //     decoration: BoxDecoration(
  //       color: color,
  //       borderRadius: BorderRadius.circular(12),
  //     ),
  //     child: Text(
  //       text,
  //       style: GoogleFonts.poppins(
  //         fontSize: 10,
  //         fontWeight: FontWeight.w500,
  //         color: Colors.white,
  //       ),
  //     ),
  //   );
  // }

  void _handleDeleteTask(TaskModel task) {
    context.read<TaskBloc>().add(DeleteTask(taskId: task.id));
  }

  void _toggleTaskStatus(TaskModel task) {
    final isCompleted = task.status == TaskStatus.completed;
    context.read<TaskBloc>().add(ToggleTaskStatus(
          taskId: task.id,
          isCompleted: !isCompleted,
        ));
  }

  void _editTask(TaskModel task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTaskPage(
          userId: _currentUserId!,
          task: task,
        ),
      ),
    ).then((_) {
      // Refresh tasks when returning from edit page
      if (_currentUserId != null) {
        // ignore: use_build_context_synchronously
        context.read<TaskBloc>().add(LoadTasks(userId: _currentUserId!));
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
