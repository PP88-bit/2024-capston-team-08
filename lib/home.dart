import 'package:flutter/material.dart';
import 'song_selection.dart';
import 'chatbot_feedback.dart';
import 'settings.dart'; // settings.dart 파일 import

class HomeScreen extends StatefulWidget {
  final String userId; // userId를 String으로 선언

  const HomeScreen({super.key, required this.userId});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    const HomeContent(), // 홈 화면 내용
    const SongSelectionScreen(), // 연습 화면 내용
    const ChatbotScreen(), // 피드백 화면 내용
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 배경을 하얀색으로 설정
      appBar: _selectedIndex == 0
          ? AppBar(
              title: const Text('홈', style: TextStyle(color: Colors.black)),
              backgroundColor: Colors.white,
              elevation: 0, // 그림자 제거
              actions: [
                IconButton(
                  icon:
                      const Icon(Icons.settings, color: Colors.black), // 설정 아이콘
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SettingsPage(userId: widget.userId), // userId 전달
                      ),
                    );
                  },
                ),
              ],
            )
          : null, // 선택된 탭이 홈이 아니면 AppBar를 null로 설정
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex), // 선택된 페이지 표시
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromRGBO(252, 252, 252, 1),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: '연습',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: '피드백',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green, // 선택된 아이템 색상
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/piano.png', // 피아노 이미지
          height: 300,
        ),
      ],
    );
  }
}
