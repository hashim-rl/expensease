import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:expensease/screens/auth/auth_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/logo.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });

    _controller.setLooping(false);

    // Automatically navigate when video ends
    _controller.addListener(() {
      if (_controller.value.isInitialized &&
          _controller.value.position >= _controller.value.duration) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AuthPage()),
        );
      }
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
      backgroundColor: Colors.black, // Change this if needed
      body: _controller.value.isInitialized
          ? SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: _controller.value.size.width,
            height: _controller.value.size.height,
            child: VideoPlayer(_controller),
          ),
        ),
      )
          : const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
    );
  }
}
