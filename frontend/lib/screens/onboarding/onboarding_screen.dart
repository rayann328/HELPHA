import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_strings.dart';
import '../auth/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingData> _pages = [
    _OnboardingData(
      icon: Icons.medication_liquid_rounded,
      titleKey: 'manageMedications',
      descriptionKey: 'manageMedicationsDescription',
    ),
    _OnboardingData(
      icon: Icons.notifications_active_rounded,
      titleKey: 'neverMissDose',
      descriptionKey: 'neverMissDoseDescription',
    ),
    _OnboardingData(
      icon: Icons.insights_rounded,
      titleKey: 'trackProgress',
      descriptionKey: 'trackProgressDescription',
    ),
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _goToLogin();
    }
  }

  void _goToLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => LoginScreen()),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton(
                onPressed: _goToLogin,
                child: Text(AppStrings.get(context, 'skipIntro')),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.10),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            page.icon,
                            size: 90,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(height: 50),
                        Text(
                          AppStrings.get(context, page.titleKey),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 18),
                        Text(
                          AppStrings.get(context, page.descriptionKey),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.5,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_pages.length, (index) {
                final isActive = index == _currentPage;
                return AnimatedContainer(
                  duration: Duration(milliseconds: 250),
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  width: isActive ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.primary : AppColors.border,
                    borderRadius: BorderRadius.circular(10),
                  ),
                );
              }),
            ),
            SizedBox(height: 28),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 28),
              child: ElevatedButton(
                onPressed: _nextPage,
                child: Text(
                  _currentPage == _pages.length - 1
                      ? AppStrings.get(context, 'getStarted')
                      : AppStrings.get(context, 'next'),
                ),
              ),
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _OnboardingData {
  final IconData icon;
  final String titleKey;
  final String descriptionKey;

  _OnboardingData({
    required this.icon,
    required this.titleKey,
    required this.descriptionKey,
  });
}
