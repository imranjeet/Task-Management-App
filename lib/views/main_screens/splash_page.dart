import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_management_app/core/constants/string_constants.dart';
import '../../core/services/local_storage_service.dart';
import '../../core/constants/app_constants.dart';
import '../auth/presentation/pages/onboarding_page.dart';
import '../auth/presentation/pages/login_page.dart';
import '../task/presentation/pages/task_list_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppConstants.animationDuration,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _animationController.forward();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Wait for splash animation
    await Future.delayed(AppConstants.animationDuration);

    if (!mounted) return;

    // Check if onboarding is completed
    final isOnboardingCompleted =
        await LocalStorageService.isOnboardingCompleted();

    if (!mounted) return;

    if (!isOnboardingCompleted) {
      // Show onboarding
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const OnboardingPage()),
      );
    } else {
      // Check Firebase Auth for current user
      final currentUser = FirebaseAuth.instance.currentUser;

      if (!mounted) return;

      if (currentUser != null) {
        // User is authenticated, go to task list
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const TaskListPage()),
        );
      } else {
        // User needs to login
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.buttonColor,
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // App Icon
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                            AppConstants.borderRadiusLarge + 8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.check,
                        color: AppConstants.buttonColor,
                        size: 50,
                      ),
                    ),

                    const SizedBox(height: AppConstants.paddingLarge),

                    // App Name
                    Text(
                      StringConstants.appName,
                      style: AppConstants.headingStyle.copyWith(
                        fontSize: 32,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: AppConstants.paddingSmall),

                    // Tagline
                    Text(
                      StringConstants.splashTagline,
                      style: AppConstants.bodyStyle.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),

                    const SizedBox(height: AppConstants.paddingXLarge + 8),

                    // Loading indicator
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
