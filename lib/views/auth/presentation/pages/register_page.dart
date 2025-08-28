import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/string_constants.dart';
import '../bloc/auth_bloc.dart';
import '../../../task/presentation/pages/task_list_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isEmailValid = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateEmail(String email) {
    setState(() {
      _isEmailValid =
          email.contains('@') && email.contains('.') && email.length > 5;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) async {
          if (state is AuthSuccess) {
            if (mounted) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const TaskListPage()),
                (route) => false,
              );
            }
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppConstants.errorColor,
              ),
            );
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingLarge),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: AppConstants.paddingLarge + 16),

                  // Decorative background elements
                  Stack(
                    children: [
                      // Background decorative elements
                      Positioned(
                        top: -20,
                        left: -20,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.orange.withValues(alpha: 0.3),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 40,
                        right: -10,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.blue.withValues(alpha: 0.3),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 80,
                        left: 50,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.orange.withValues(alpha: 0.5),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),

                      // Main icon
                      Center(
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: AppConstants.buttonColor,
                            borderRadius: BorderRadius.circular(
                                AppConstants.borderRadiusLarge + 4),
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppConstants.paddingLarge + 16),

                  // Welcome text
                  Text(
                    StringConstants.registerWelcome,
                    style: AppConstants.headingStyle.copyWith(
                      fontSize: 28,
                      color: AppConstants.textPrimaryColor,
                    ),
                  ),

                  const SizedBox(height: AppConstants.paddingLarge + 16),

                  // Email field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        StringConstants.emailAddress,
                        style: AppConstants.captionStyle.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppConstants.textSecondaryColor,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: AppConstants.paddingSmall),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                              AppConstants.borderRadiusLarge),
                          border:
                              Border.all(color: AppConstants.textLightColor),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _emailController,
                                onChanged: _validateEmail,
                                keyboardType: TextInputType.emailAddress,
                                style: AppConstants.bodyStyle.copyWith(
                                  color: AppConstants.textPrimaryColor,
                                ),
                                decoration: const InputDecoration(
                                  hintText: StringConstants.enterEmail,
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 16,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return StringConstants.pleaseEnterEmail;
                                  }
                                  if (!value.contains('@')) {
                                    return StringConstants
                                        .pleaseEnterValidEmail;
                                  }
                                  return null;
                                },
                              ),
                            ),
                            if (_emailController.text.isNotEmpty)
                              Container(
                                margin: const EdgeInsets.only(
                                    right: AppConstants.paddingMedium),
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: _isEmailValid
                                      ? AppConstants
                                          .successColor // Green for valid
                                      : AppConstants
                                          .textSecondaryColor, // Grey for invalid
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  _isEmailValid ? Icons.check : Icons.close,
                                  color: Colors.white,
                                  size: 12,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppConstants.paddingLarge),

                  // Password field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        StringConstants.password,
                        style: AppConstants.captionStyle.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppConstants.textSecondaryColor,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: AppConstants.paddingSmall),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                              AppConstants.borderRadiusLarge),
                          border:
                              Border.all(color: AppConstants.textLightColor),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                style: AppConstants.bodyStyle.copyWith(
                                  color: AppConstants.textPrimaryColor,
                                ),
                                decoration: const InputDecoration(
                                  hintText: StringConstants.enterPassword,
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 16,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return StringConstants.pleaseEnterPassword;
                                  }
                                  return null;
                                },
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: AppConstants.textSecondaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppConstants.paddingXLarge),

                  // Sign up button
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed:
                              state is AuthLoading ? null : _handleRegister,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppConstants.buttonColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  AppConstants.borderRadiusLarge),
                            ),
                            elevation: 0,
                          ),
                          child: state is AuthLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : Text(
                                  StringConstants.signUpButton,
                                  style: AppConstants.buttonStyle,
                                ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: AppConstants.paddingLarge),

                  // Social signup
                  Text(
                    StringConstants.orSignUpWith,
                    style: AppConstants.captionStyle.copyWith(
                      color: AppConstants.textSecondaryColor,
                    ),
                  ),

                  const SizedBox(height: AppConstants.paddingLarge),

                  // Social buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSocialButton(
                        icon: 'f',
                        color: const Color(0xFF1877F2),
                        onPressed: () {},
                      ),
                      const SizedBox(width: AppConstants.paddingMedium),
                      _buildSocialButton(
                        icon: 'G',
                        color: const Color(0xFFDB4437),
                        onPressed: () {},
                      ),
                      const SizedBox(width: AppConstants.paddingMedium),
                      _buildSocialButton(
                        icon: Icons.apple,
                        color: Colors.black,
                        onPressed: () {},
                      ),
                    ],
                  ),

                  const SizedBox(height: AppConstants.paddingLarge + 16),

                  // Login link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        StringConstants.alreadyAccount,
                        style: AppConstants.captionStyle.copyWith(
                          color: AppConstants.textSecondaryColor,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          StringConstants.loginLink,
                          style: AppConstants.captionStyle.copyWith(
                            color: AppConstants.buttonColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppConstants.paddingLarge + 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required dynamic icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: icon is String
              ? Text(
                  icon,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : Icon(
                  icon,
                  color: Colors.white,
                  size: 24,
                ),
        ),
      ),
    );
  }

  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            SignUpRequested(
              email: _emailController.text.trim(),
              password: _passwordController.text,
              displayName: '',
            ),
          );
    }
  }
}
