import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:relay_repo/core/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _slides = [
    {
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBKub-qOR-Ij6ljwhzL2EG7k63zlJJ-W9BRxXDOiwceHMN7aXvF3JuBhV9yZEWBemcw_0CFvWwOZqIKb4AYQY3VMvxRu4MKHlvhgnObganbjwdxGa_BvvOv33otyv2e1lWvuVCMDnB-2GciuZHCu1uF_vHfvmQnMEETT0WU_2h-u_9p9DJmXBqAq5U01xNaUmZ65Q9l0nPkV10duhhEm69g3j5FPbEy0s5acRT34Kwxdf0-m2XH_neJEli7Oacne4EQPKWCrXaYw_o',
      'title': 'Save videos from anywhere',
      'description':
          'Effortlessly capture and store content from all your favorite platforms in one place.',
    },
    {
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBo9PU2JTMHXX1lEVgj5j3o0Vmebkc3nno1Hluc-_ZWHVaUmpKFA2JL7KGLjR32vCWYlxbvbA88R8iqG3ZxBBf8y_1dckESHRt9GbHBUXymfWvDq_jvSdo2rkyCp7RJO1khTs_XnzYhc3pF0pyCecBOIfzGcjTpeEux307TQlYclHyyfePo2xjM7CPxXVFctdnl6neu5iRQ3C7lX_j95AuemM5tVyBPVz7RbtfHV-KD-yBVJPtOijih_yZNJd5--a_QHJgLufeg8vE',
      'title': 'Organize your favorites easily',
      'description':
          'Create custom collections, add tags, and find what you\'re looking for in seconds.',
    },
    {
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAkXZN0fZktx0Uhxt4ICwEnZiR7lEGQUsh961sKRiw_1nKTGCwcTZBPVqniQPpRRBWz8jkEb--4WlJvSEGe2QfjDg9Dox_cTdU41PAYA5FoiKH2gFVU8ghQigj7Hu0p4oywUkiLPx06iAmG-_d_j6cSR-1nMPERdtvzrKrNF2zgFONFchND4LhMrrESynuxoLZt5TjN77iye6zX8k2JWD2JjgH3kMAOj5RmKzb0REkfCyKPe8PhUtZGGUf1Z8pmcM7XvfCweDuEm-Y',
      'title': 'Access anytime, anywhere',
      'description':
          'Your video library is synced across all your devices, available online or offline.',
    },
  ];

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
    if (mounted) {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: Theme.of(context).brightness == Brightness.light
              ? AppTheme.liquidBackgroundGradient
              : AppTheme.liquidBackgroundGradientDark,
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: _slides.length,
                  itemBuilder: (context, index) {
                    final slide = _slides[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 40),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(32),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 30,
                                    offset: const Offset(0, 15),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(32),
                                child: CachedNetworkImage(
                                  imageUrl: slide['image']!,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Center(
                                    child: CircularProgressIndicator(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surfaceContainerHighest,
                                    child: Icon(
                                      Icons.image_not_supported_outlined,
                                      size: 64,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                Text(
                                  slide['title']!,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                        height: 1.2,
                                      ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  slide['description']!,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withValues(alpha: 0.7),
                                        height: 1.5,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 48),
                child: Column(
                  children: [
                    // Indicators
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_slides.length, (index) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          height: 8,
                          width: _currentPage == index ? 32 : 8,
                          decoration: BoxDecoration(
                            gradient: _currentPage == index
                                ? AppTheme.primaryGradient
                                : null,
                            color: _currentPage == index
                                ? null
                                : Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 48),
                    // Button
                    Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryColor.withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_currentPage == _slides.length - 1) {
                            _completeOnboarding();
                          } else {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeOutQuart,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        child: Text(
                          _currentPage == _slides.length - 1
                              ? 'Get Started'
                              : 'Next',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
