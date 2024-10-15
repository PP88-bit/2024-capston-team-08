import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart'; // 로그인 페이지 import

class SettingsPage extends StatelessWidget {
  final String userId; // userId 타입을 String으로 변경

  const SettingsPage({super.key, required this.userId});

  Future<User?> fetchUserData() async {
    // 현재 로그인한 사용자 정보 가져오기
    User? user = FirebaseAuth.instance.currentUser;
    return user;
  }

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    // 로그아웃 후 login.dart로 이동
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
  }

  Future<void> _deleteAccount(BuildContext context) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.delete(); // Firebase에서 사용자 계정 삭제
        // 계정 삭제 후 login.dart로 이동
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
      }
    } catch (e) {
      print('Failed to delete account: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('환경설정'),
        backgroundColor: Colors.white, // AppBar의 배경색을 흰색으로 설정
        iconTheme: const IconThemeData(color: Colors.black), // 아이콘 색상을 검정으로 설정
      ),
      backgroundColor: Colors.white, // 배경색을 흰색으로 설정
      body: FutureBuilder<User?>(
        future: fetchUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('User not found'));
          } else {
            final user = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 32.0),
                          child: SizedBox(
                            width: 80.0,
                            child: Text('이메일', style: TextStyle(fontSize: 18)),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: Text(
                              user.email ?? 'No email found',
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 32.0),
                          child: SizedBox(
                            width: 80.0,
                            child: Text('비밀번호', style: TextStyle(fontSize: 18)),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(right: 16.0),
                            child: Text(
                              '********', // 비밀번호는 실제로 표시하지 않음
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                      height: 20), // Add space between fields and buttons

                  // 회원탈퇴 버튼
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // 회원탈퇴 버튼 색상
                      ),
                      onPressed: () {
                        _deleteAccount(context); // 회원탈퇴 로직 호출
                      },
                      child: const Text('회원탈퇴',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),

                  const SizedBox(height: 10), // Add space between buttons

                  // 로그아웃 버튼
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey, // 로그아웃 버튼 색상
                      ),
                      onPressed: () {
                        _logout(context); // 로그아웃 로직 호출
                      },
                      child: const Text('로그아웃',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
