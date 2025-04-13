import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  late AnimationController _textAnimController;
  late Animation<double> _fadeAnimation;
  Timer? _timer;

  int _currentPage = 0;

  final List<LandingPageSlide> _pages = [
    LandingPageSlide(
      title: 'Best Helping Hands for you',
      subtitle:
          'With our on-demand services app, we give better services to you.',
      buttonText: 'Get Started',
      icon: Icons.handshake,
    ),
    LandingPageSlide(
      title: 'Choose a service',
      subtitle:
          'Find the right service for your needs easily, with a variety of options available at your fingertips.',
      buttonText: 'Next',
      icon: Icons.design_services,
    ),
    LandingPageSlide(
      title: 'Get a quote',
      subtitle:
          'Request price estimates from professionals to help you make informed decisions with ease.',
      buttonText: 'Next',
      icon: Icons.request_quote,
    ),
    LandingPageSlide(
      title: 'Work done',
      subtitle:
          'Sit back and relax while skilled experts efficiently take care of your tasks.',
      buttonText: 'Finish',
      icon: Icons.verified,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _textAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _textAnimController,
      curve: Curves.easeInOut,
    );
    _textAnimController.forward();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 8), (timer) {
      if (_currentPage < _pages.length - 1) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _textAnimController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenLandingPage', true);
    Future.microtask(
        () => Navigator.of(context).pushReplacementNamed('/phoneVerification'));
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _skip() {
    _completeOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
              _textAnimController.reset();
              _textAnimController.forward();
            },
            itemBuilder: (context, index) {
              final page = _pages[index];
              return Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 24, vertical: mediaQuery.size.height * 0.08),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        if (_currentPage > 0)
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () {
                              _pageController.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                          )
                        else
                          const SizedBox(width: 48),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Icon(page.icon, size: 100, color: const Color(0xFF007EA7)),
                    const SizedBox(height: 30),
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        children: [
                          Text(
                            page.title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            page.subtitle,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    SmoothPageIndicator(
                      controller: _pageController,
                      count: _pages.length,
                      effect: const ExpandingDotsEffect(
                        activeDotColor: Color(0xFF007EA7),
                        dotHeight: 10,
                        dotWidth: 10,
                        spacing: 8,
                      ),
                      onDotClicked: (index) {
                        _pageController.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _nextPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF007EA7),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          page.buttonText,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              );
            },
          ),
          Positioned(
            top: 40,
            right: 20,
            child: TextButton(
              onPressed: _skip,
              child: const Text(
                'Skip',
                style:
                    TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LandingPageSlide {
  final String title;
  final String subtitle;
  final String buttonText;
  final IconData icon;

  LandingPageSlide({
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.icon,
  });
}
