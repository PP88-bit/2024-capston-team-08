import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart'; // 로그인 페이지로 이동하기 위해 import

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  // 이메일로 회원가입 및 이메일 인증 보내기
  Future<void> _signUpWithEmail() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Firebase 이메일 및 비밀번호로 회원가입
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // 이메일 인증 보내기
      User? user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        _showVerificationDialog(); // 인증 이메일 발송 후 메시지 표시
      }
    } on FirebaseAuthException catch (e) {
      _showErrorDialog(e.message!);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // 이메일 인증 발송 후 사용자에게 알림
  void _showVerificationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('이메일 인증 필요'),
          content: const Text('회원가입이 완료되었습니다. '
              '계속하려면 이메일을 확인하고 인증 링크를 클릭해주세요.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // 이메일 인증 후 로그인 화면으로 이동
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 233, 255, 233),
          title: const Text(
            '회원가입 실패',
          ),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 배경색을 흰색으로 설정
      appBar: AppBar(
        title: const Text('회원가입'),
        backgroundColor:
            const Color.fromARGB(255, 255, 255, 255), // AppBar 배경색을 초록색으로 설정
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: '이메일'),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _passwordController,
                      decoration: const InputDecoration(labelText: '비밀번호'),
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _signUpWithEmail,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green, // 회원가입 버튼 색상을 초록색으로 변경
                      ),
                      child: const Text(
                        '이메일로 회원가입',
                        style: TextStyle(color: Colors.white), // 버튼 텍스트 색상 설정
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
