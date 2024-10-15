import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'dart:html' as html;

class SongSelectionScreen extends StatefulWidget {
  const SongSelectionScreen({super.key});

  @override
  SongSelectionScreenState createState() => SongSelectionScreenState();
}

class SongSelectionScreenState extends State<SongSelectionScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedInstrument = 'piano'; // 기본 악기 선택

  Future<void> _pickFile() async {
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.accept = '.mp3';
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      if (files!.isNotEmpty) {
        final file = files[0];
        final reader = html.FileReader();

        reader.onLoadEnd.listen((e) async {
          // 파일 업로드 후 피드백 처리
          print("File is ready for upload");
          await _uploadFile(file, reader.result as Uint8List);
        });

        reader.readAsArrayBuffer(file);
      }
    });
  }

  Future<void> _uploadFile(html.File file, Uint8List fileBytes) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://127.0.0.1:5000/upload'),
    );
    request.files.add(
      http.MultipartFile.fromBytes(
        'file',
        fileBytes,
        filename: file.name,
      ),
    );
    request.fields['instrument'] =
        _selectedInstrument.toLowerCase(); // 악기 선택 추가

    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        print("Upload successful: $responseData");

        // 위젯이 여전히 활성 상태인지 확인
        if (mounted) {
          // 성공 메시지 표시
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('트랙이 성공적으로 업로드되었습니다: $responseData')),
          );
        }
      } else {
        print("Upload failed: ${response.reasonPhrase}");

        // 위젯이 여전히 활성 상태인지 확인
        if (mounted) {
          // 실패 메시지 표시
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('파일 업로드 실패: ${response.reasonPhrase}')),
          );
        }
      }
    } catch (e) {
      // 오류 메시지 표시
      print("Upload error: $e");

      // 위젯이 여전히 활성 상태인지 확인
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('파일 업로드 중 오류 발생: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 배경색을 white로 설정
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          '악기를 선택하세요',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: DropdownButton<String>(
              value: _selectedInstrument,
              items: <String>['piano', 'guitar', 'bass', 'drums']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedInstrument = newValue!;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '곡을 검색하세요',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.file_upload),
                  onPressed: _pickFile,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
