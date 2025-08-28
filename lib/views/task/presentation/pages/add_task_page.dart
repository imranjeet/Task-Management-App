// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../shared/models/task_model.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/string_constants.dart';
import '../bloc/task_bloc.dart';

class AddTaskPage extends StatefulWidget {
  final String userId;
  final TaskModel? task;

  const AddTaskPage({
    super.key,
    required this.userId,
    this.task,
  });

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TaskPriority _selectedPriority = TaskPriority.medium;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
      _selectedDate = widget.task!.dueDate;
      _selectedPriority = widget.task!.priority;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // Custom SliverAppBar matching TaskListPage
          SliverAppBar(
            expandedHeight: 120,
            floating: true,
            pinned: true,
            backgroundColor: AppConstants.primaryColor,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
              onPressed: () => Navigator.of(context).pop(),
            ),
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
                        const Spacer(),
                        Text(
                          widget.task != null
                              ? StringConstants.editTask
                              : StringConstants.addNewTask,
                          style: AppConstants.captionStyle.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          widget.task != null
                              ? StringConstants.updateTask
                              : StringConstants.createNewTask,
                          style: AppConstants.titleLargeStyle.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Pinned title
            title: Text(
              widget.task != null
                  ? StringConstants.editTask
                  : StringConstants.addNewTask,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Form content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.paddingMedium + 4),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title Field
                    _buildFormField(
                      label: StringConstants.taskTitle,
                      hint: StringConstants.taskTitle,
                      controller: _titleController,
                      icon: Icons.title,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return StringConstants.pleaseEnterTitle;
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    // Description Field
                    _buildFormField(
                      label: StringConstants.taskDescription,
                      hint: StringConstants.taskDescription,
                      controller: _descriptionController,
                      icon: Icons.description,
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return StringConstants.pleaseEnterDescription;
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    // Due Date Field
                    _buildDateField(),

                    const SizedBox(height: 20),

                    // Priority Field
                    _buildPrioritySection(),

                    const SizedBox(height: 40),

                    // Save Button
                    BlocListener<TaskBloc, TaskState>(
                      listener: (context, state) {
                        if (state is TaskSuccess) {
                          // Task was created/updated successfully
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.message),
                              backgroundColor: const Color(0xFF10B981),
                            ),
                          );
                        } else if (state is TaskError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.message),
                              backgroundColor: const Color(0xFFEF4444),
                            ),
                          );
                        }
                      },
                      child: BlocBuilder<TaskBloc, TaskState>(
                        builder: (context, state) {
                          return _buildSaveButton(state is TaskLoading);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppConstants.titleStyle.copyWith(
            color: AppConstants.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
            border: Border.all(color: const Color(0xFFE5E7EB)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            maxLines: maxLines,
            validator: validator,
            style: AppConstants.bodyStyle.copyWith(
              color: AppConstants.textPrimaryColor,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppConstants.bodyStyle.copyWith(
                color: AppConstants.textSecondaryColor,
              ),
              prefixIcon: Icon(
                icon,
                color: AppConstants.buttonColor,
                size: 20,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          StringConstants.dueDate,
          style: AppConstants.titleStyle.copyWith(
            color: AppConstants.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _selectDate,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(AppConstants.borderRadiusLarge),
              border: Border.all(color: const Color(0xFFE5E7EB)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  color: AppConstants.buttonColor,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  DateFormat('MMM dd, yyyy').format(_selectedDate),
                  style: AppConstants.bodyStyle.copyWith(
                    color: AppConstants.textPrimaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPrioritySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          StringConstants.priority,
          style: AppConstants.titleStyle.copyWith(
            color: AppConstants.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
            border: Border.all(color: const Color(0xFFE5E7EB)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: TaskPriority.values.map((priority) {
              Color priorityColor;
              String priorityText;

              switch (priority) {
                case TaskPriority.low:
                  priorityColor = AppConstants.lowPriorityColor;
                  priorityText = StringConstants.priorityLow;
                  break;
                case TaskPriority.medium:
                  priorityColor = AppConstants.mediumPriorityColor;
                  priorityText = StringConstants.priorityMedium;
                  break;
                case TaskPriority.high:
                  priorityColor = AppConstants.highPriorityColor;
                  priorityText = StringConstants.priorityHigh;
                  break;
              }

              return RadioListTile<TaskPriority>(
                title: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: priorityColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      priorityText,
                      style: AppConstants.bodyStyle.copyWith(
                        color: AppConstants.textPrimaryColor,
                      ),
                    ),
                  ],
                ),
                value: priority,
                groupValue: _selectedPriority,
                onChanged: (value) {
                  setState(() {
                    _selectedPriority = value!;
                  });
                },
                activeColor: priorityColor,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton(bool isLoading) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppConstants.primaryColor, AppConstants.secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppConstants.primaryColor.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : _handleSave,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 2,
                ),
              )
            : Text(
                widget.task != null
                    ? StringConstants.updateTask
                    : StringConstants.createNewTask,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      final task = TaskModel.create(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        dueDate: _selectedDate,
        priority: _selectedPriority,
        userId: widget.userId,
      );

      if (widget.task != null) {
        // Update existing task
        final updatedTask = widget.task!.copyWith(
          title: task.title,
          description: task.description,
          dueDate: task.dueDate,
          priority: task.priority,
          updatedAt: DateTime.now(),
        );
        context.read<TaskBloc>().add(UpdateTask(task: updatedTask));
      } else {
        // Create new task
        context.read<TaskBloc>().add(CreateTask(task: task));
      }
    }
  }
}
