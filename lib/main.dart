import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Firebase 자동 생성된 옵션 파일
import 'splash_screen.dart'; // SplashScreen import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase 초기화
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '잼밴드',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const SplashScreen(), // SplashScreen을 앱의 첫 화면으로 설정
    );
  }
}
