import 'package:flutter/material.dart';
import 'package:task_management_app/core/constants/string_constants.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../../../core/constants/app_constants.dart';
import 'login_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPageData> _pages = [
    OnboardingPageData(
      title: StringConstants.onboardingPage1Title,
      subtitle: StringConstants.onboardingPage1Subtitle,
      icon: Icons.check,
    ),
    OnboardingPageData(
      title: StringConstants.onboardingPage2Title,
      subtitle: StringConstants.onboardingPage2Subtitle,
      icon: Icons.list_alt,
    ),
    OnboardingPageData(
      title: StringConstants.onboardingPage3Title,
      subtitle: StringConstants.onboardingPage3Subtitle,
      icon: Icons.trending_up,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _onGetStarted() async {
    await LocalStorageService.setOnboardingCompleted();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background decorative shapes
          Positioned(
            bottom: -100,
            right: -100,
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
            left: -50,
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
            child: Column(
              children: [
                // PageView
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    itemCount: _pages.length,
                    itemBuilder: (context, index) {
                      return _buildPage(_pages[index]);
                    },
                  ),
                ),

                // Bottom section
                Padding(
                  padding: const EdgeInsets.all(AppConstants.paddingLarge),
                  child: Row(
                    children: [
                      // Page indicators
                      Row(
                        children: List.generate(
                          _pages.length,
                          (index) => Container(
                            margin: const EdgeInsets.only(
                                right: AppConstants.paddingSmall),
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: index == _currentPage
                                  ? AppConstants.buttonColor
                                  : AppConstants.textLightColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),

                      const Spacer(),

                      // Next/Get Started button
                      GestureDetector(
                        onTap: () {
                          if (_currentPage < _pages.length - 1) {
                            _pageController.nextPage(
                              duration: AppConstants.animationDuration,
                              curve: Curves.easeInOut,
                            );
                          } else {
                            _onGetStarted();
                          }
                        },
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: AppConstants.buttonColor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppConstants.buttonColor
                                    .withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            _currentPage < _pages.length - 1
                                ? Icons.arrow_forward
                                : Icons.check,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(OnboardingPageData pageData) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: AppConstants.paddingLarge),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
                top: 120,
                right: 30,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.4),
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
                  child: Icon(
                    pageData.icon,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppConstants.paddingLarge + 16),

          // Main text
          Text(
            pageData.title,
            style: AppConstants.headingStyle.copyWith(
              fontSize: 28,
              color: AppConstants.textPrimaryColor,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppConstants.paddingMedium),

          // Subtitle
          Text(
            pageData.subtitle,
            style: AppConstants.bodyStyle.copyWith(
              color: AppConstants.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class OnboardingPageData {
  final String title;
  final String subtitle;
  final IconData icon;

  OnboardingPageData({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}
