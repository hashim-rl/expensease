import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'auth/auth_page.dart'; // <-- This was missing

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _logoAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    _logoAnimation = Tween<Offset>(
      begin: Offset(0.0, 1.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();

    Future.delayed(Duration(seconds: 3), () {
      Get.off(() => const AuthPage()); // <-- fixed reference
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf5f7fa),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SlideTransition(
              position: _logoAnimation,
              child: Image.asset(
                'assets/logo.png',
                height: 120,
              ),
            ),
            SizedBox(height: 24),
            Text(
              "ExpensEase",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
                letterSpacing: 1.2,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Make Every Split Effortless",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            )
          ],
        ),
      ),
    );
  }
}
