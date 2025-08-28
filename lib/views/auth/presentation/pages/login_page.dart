import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/string_constants.dart';
import '../../../task/presentation/pages/task_list_page.dart';
import '../bloc/auth_bloc.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: '');
  final _passwordController = TextEditingController(text: '');
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
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const TaskListPage()),
            );
          }
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppConstants.errorColor,
            ),
          );
        } else if (state is AuthLoading) {
          debugPrint('Auth Loading...'); // Debug print
        }
      },
      child: SafeArea(
        child: Stack(
          children: [
            // Background decorative shapes
            Positioned(
              top: -100,
              left: -100,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: AppConstants.buttonColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: -50,
              right: -50,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppConstants.buttonColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // Main content
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.paddingLarge),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: AppConstants.paddingXLarge + 12),

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
                          Positioned(
                            top: 60,
                            left: -10,
                            child: Icon(
                              Icons.star,
                              color: Colors.orange.withValues(alpha: 0.4),
                              size: 16,
                            ),
                          ),
                          Positioned(
                            top: 100,
                            right: 60,
                            child: Icon(
                              Icons.star,
                              color: Colors.blue.withValues(alpha: 0.3),
                              size: 12,
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
                        StringConstants.loginWelcome,
                        style: AppConstants.headingStyle.copyWith(
                          fontSize: 28,
                          color: AppConstants.textPrimaryColor,
                        ),
                        textAlign: TextAlign.center,
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
                            ),
                          ),
                          const SizedBox(height: AppConstants.paddingSmall),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: AppConstants.textLightColor),
                              borderRadius: BorderRadius.circular(
                                  AppConstants.borderRadiusLarge),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    onChanged: _validateEmail,
                                    decoration: const InputDecoration(
                                      hintText: StringConstants.enterEmail,
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.all(16),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                StringConstants.password,
                                style: AppConstants.captionStyle.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: AppConstants.textSecondaryColor,
                                ),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: Text(
                                  StringConstants.forgotPassword,
                                  style: AppConstants.captionStyle.copyWith(
                                    color: AppConstants.buttonColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppConstants.paddingSmall),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: AppConstants.textLightColor),
                              borderRadius: BorderRadius.circular(
                                  AppConstants.borderRadiusLarge),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _passwordController,
                                    obscureText: _obscurePassword,
                                    decoration: const InputDecoration(
                                      hintText: StringConstants.enterPassword,
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.all(16),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return StringConstants
                                            .pleaseEnterPassword;
                                      }
                                      if (value.length < 6) {
                                        return StringConstants
                                            .passwordMinLength;
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
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: AppConstants.textSecondaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: AppConstants.paddingXLarge),

                      // Login button
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          return SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed:
                                  state is AuthLoading ? null : _handleLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppConstants.buttonColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      AppConstants.borderRadiusLarge),
                                ),
                              ),
                              child: state is AuthLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(
                                      StringConstants.loginButton,
                                      style: AppConstants.buttonStyle.copyWith(
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: AppConstants.paddingLarge),

                      // Social login
                      Text(
                        StringConstants.orLoginWith,
                        style: AppConstants.captionStyle.copyWith(
                          color: AppConstants.textSecondaryColor,
                        ),
                      ),

                      const SizedBox(height: AppConstants.paddingMedium),

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
                            icon: Icons.g_mobiledata,
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

                      // Register link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            StringConstants.noAccount,
                            style: AppConstants.captionStyle.copyWith(
                              color: AppConstants.textSecondaryColor,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const RegisterPage(),
                                ),
                              );
                            },
                            child: Text(
                              StringConstants.getStarted,
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
          ],
        ),
      ),
    ));
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

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            SignInRequested(
              email: _emailController.text.trim(),
              password: _passwordController.text,
            ),
          );
    }
  }
}
