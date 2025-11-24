import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
      body: SafeArea(
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
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Image.network(
                            slide['image']!,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          slide['title']!,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          slide['description']!,
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Colors.grey,
                                  ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
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
                        width: _currentPage == index ? 24 : 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? Theme.of(context).primaryColor
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 32),
                  // Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: FilledButton(
                      onPressed: () {
                        if (_currentPage == _slides.length - 1) {
                          _completeOnboarding();
                        } else {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      child: Text(
                        _currentPage == _slides.length - 1
                            ? 'Get Started'
                            : 'Next',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
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
    );
  }
}
