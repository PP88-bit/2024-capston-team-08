import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key, Key? newkey});

  @override
  ChatbotScreenState createState() => ChatbotScreenState();
}

class ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _messages = [];

  Future<void> _sendMessage() async {
    var userMessage = _controller.text;
    setState(() {
      _messages.add('User: $userMessage');
    });
    _controller.clear();
    var botMessage = await getGptResponse(userMessage);
    setState(() {
      _messages.add('Bot: $botMessage');
    });
  }

  Future<String> getGptResponse(String message) async {
    var url = Uri.parse(
        'https://api.openai.com/v1/chat/completions'); //플라스크 주소로 변경하면 플라스크에 응답이 감
    var apiKey =
        'sk-proj-N185T7PswdK8IBsB68TgT3BlbkFJI1r2AyxvbqYwM2HFIQHs'; // 본인의 API 키로 변경하세요
    var headers = {
      'Content-Type': 'application/json; charset=utf-8',
      'Authorization': 'Bearer $apiKey',
    };
    var body = jsonEncode({
      'model': 'gpt-3.5-turbo',
      'messages': [
        {
          'role': 'system',
          'content':
              ' You provide feedback to help users improve their playing based on their instrument and the accuracy of their playing. You always use polite sentence and Korean.'
        },
        {'role': 'user', 'content': message},
      ],
      'max_tokens': 150,
    });

    var response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      var gptResponse = data['choices'][0]['message']['content'];
      return gptResponse.trim();
    } else {
      return 'Error: ${response.statusCode}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 배경을 하얀색으로 설정
      appBar: AppBar(
        title: const Text('Chatbot'),
        backgroundColor: const Color.fromRGBO(252, 252, 252, 1),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                bool isUserMessage = _messages[index].startsWith('User: ');
                return Container(
                  alignment: isUserMessage
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                    ),
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isUserMessage ? Colors.blue : Colors.green,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        Text(
                          _messages[index].replaceFirst(
                              isUserMessage ? 'User: ' : 'Bot: ', ''),
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Pretendard',
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: '궁금한 점을 물어보세요!',
                    hintStyle:
                        const TextStyle(color: Colors.grey), // 힌트 텍스트 스타일 변경
                    border: OutlineInputBorder(
                      // 보더 스타일 변경
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.blue),
                    ),
                    enabledBorder: OutlineInputBorder(
                      // 활성화되지 않은 상태의 보더 스타일 변경
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      // 포커스를 받았을 때의 보더 스타일 변경
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.green),
                    ),
                  ),
                  onSubmitted: (text) => _sendMessage(),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: _sendMessage,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
