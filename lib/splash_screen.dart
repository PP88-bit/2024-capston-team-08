import 'package:flutter/material.dart';
import 'login.dart'; // 로그인 페이지 import

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  _navigateToLogin() async {
    await Future.delayed(const Duration(seconds: 2), () {
      // 2초 뒤에 로그인 페이지로 이동
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 배경을 하얀색으로 설정
      body: Center(
        child: Image.asset('assets/logo.png'), // 로고 이미지 경로 설정
      ),
    );
  }
}
