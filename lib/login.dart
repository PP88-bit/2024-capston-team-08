import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'signup.dart'; // 회원가입 페이지 import
import 'home.dart'; // HomeScreen 페이지 import

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Firebase 로그인
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // 로그인 성공 시 홈 화면으로 이동
      User? user = _auth.currentUser;
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                HomeScreen(userId: user.uid), // HomeScreen으로 이동하며 userId 전달
          ),
        );
      }
      print('로그인 성공: ${userCredential.user}');
    } on FirebaseAuthException catch (e) {
      _showErrorDialog(e.message!);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('로그인 실패'),
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
      backgroundColor: Colors.white, // 배경을 하얀색으로 설정
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 로고 이미지
                Image.asset(
                  'assets/logo.png', // logo.png 경로에 맞게 설정
                  height: 200, // 로고 사이즈
                ),
                const SizedBox(height: 40),

                // 아이디 입력란
                SizedBox(
                  width: MediaQuery.of(context).size.width - 10, // 좌우 5픽셀씩 줄임
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: '아이디',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // 비밀번호 입력란
                SizedBox(
                  width: MediaQuery.of(context).size.width - 10, // 좌우 5픽셀씩 줄임
                  child: TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: '비밀번호',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.visibility_off),
                        onPressed: () {
                          // 비밀번호 보기 기능 구현 가능
                        },
                      ),
                    ),
                    obscureText: true,
                  ),
                ),
                const SizedBox(height: 20),

                // 회원가입 버튼 (오른쪽 정렬)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end, // 오른쪽 정렬
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpPage()),
                        );
                      },
                      child: const Text('회원가입'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // 로그인 버튼
                SizedBox(
                  width: MediaQuery.of(context).size.width - 10, // 좌우 5픽셀씩 줄임
                  child: ElevatedButton(
                    onPressed: _login, // 로그인 버튼 클릭 시 _login 호출
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // 초록색 버튼
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    child: const Text(
                      '로그인',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
