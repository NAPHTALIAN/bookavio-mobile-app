import 'package:flutter/material.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  final List<OnboardingSlide> _slides = [
    OnboardingSlide(
      title: 'Welcome To Bookavio',
      description:
          'Your trusted platform for discovering and booking personalized services in your local area.',
      imagePath: 'assets/logo.png',
      hasCustomBackground: true,
    ),
    OnboardingSlide(
      title: 'Book With Ease',
      description:
          'Schedule appointments effortlessly with our user-friendly booking system',
      icon: Icons.calendar_today,
      hasCustomBackground: true,
    ),
    OnboardingSlide(
      title: 'Explore Services',
      description:
          'Browse a wide range of personalized services tailored to your needs',
      icon: Icons.people,
      hasCustomBackground: true,
    ),
    OnboardingSlide(
      title: 'Get Started Now',
      description: 'Join Bookavio and start exploring services today',
      icon: Icons.local_offer,
      hasCustomBackground: true,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onSlideChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _nextSlide() {
    if (_currentIndex < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: _onSlideChanged,
                children: _slides.map((slide) {
                  return _buildOnboardingSlide(context, slide);
                }).toList(),
              ),
            ),
            // Custom indicator
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _slides.length,
                  (index) => Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentIndex == index
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey.shade300,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentIndex > 0)
                    TextButton(
                      onPressed: () {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                      ),
                      child: const Text('Previous'),
                    )
                  else
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        foregroundColor: Colors.red,
                      ),
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ElevatedButton(
                    onPressed: _nextSlide,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      _currentIndex == _slides.length - 1
                          ? 'Get Started'
                          : 'Next',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnboardingSlide(BuildContext context, OnboardingSlide slide) {
    return Container(
      decoration: slide.hasCustomBackground == true
          ? BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Colors.green.shade600,
                  Colors.white,
                ],
                stops: const [0.0, 0.6],
              ),
            )
          : null,
      child: Stack(
        children: [
          if (slide.hasCustomBackground == true)
            Positioned(
              top: -50,
              right: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green.shade400.withOpacity(0.2),
                ),
              ),
            ),
          if (slide.hasCustomBackground == true)
            Positioned(
              bottom: -30,
              left: -30,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green.shade300.withOpacity(0.15),
                ),
              ),
            ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  Container(
                    width: 220,
                    height: 220,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: slide.imagePath != null
                        ? Image.asset(
                            slide.imagePath!,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                slide.icon ?? Icons.image,
                                size: 100,
                                color: Colors.green.shade600,
                              );
                            },
                          )
                        : Icon(
                            slide.icon!,
                            size: 100,
                            color: Colors.green.shade600,
                          ),
                  ),
          const SizedBox(height: 60),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
          Text(
            slide.title,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
              fontWeight: FontWeight.w600,
                                color: Colors.green.shade800,
                                height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
                        const SizedBox(height: 16),
          Text(
            slide.description,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Colors.grey[700],
              height: 1.5,
                                    letterSpacing: 0.3,
                                  ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingSlide {
  final String title;
  final String description;
  final IconData? icon;
  final String? imagePath;
  final bool? hasCustomBackground;

  OnboardingSlide({
    required this.title,
    required this.description,
    this.icon,
    this.imagePath,
    this.hasCustomBackground,
  });
} 
