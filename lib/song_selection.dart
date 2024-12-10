import 'dart:typed_data'; // Uint8List를 사용하기 위해 추가
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';

class SongSelectionScreen extends StatefulWidget {
  const SongSelectionScreen({super.key});

  @override
  SongSelectionScreenState createState() => SongSelectionScreenState();
}

class SongSelectionScreenState extends State<SongSelectionScreen> {
  String _selectedInstrument = 'piano';
  bool _isLoading = false; // 로딩 상태 관리

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp3', 'mid'],
        withData: true, // 파일 데이터를 읽도록 설정
      );

      if (result != null && result.files.single.bytes != null) {
        final fileBytes = result.files.single.bytes!;
        final fileName = result.files.single.name;

        setState(() {
          _isLoading = true; // 로딩 상태로 전환
        });
        await _uploadAndConvert(fileBytes, fileName);
      } else {
        print("파일 선택이 취소되었습니다.");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('파일 선택이 취소되었습니다.')),
        );
      }
    } catch (e) {
      print("파일 선택 중 오류 발생: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('파일 선택 중 오류 발생: $e')),
      );
    }
  }

  Future<void> _uploadAndConvert(Uint8List fileBytes, String fileName) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://127.0.0.1:5000/upload'),
      );

      request.files.add(http.MultipartFile.fromBytes(
        'file',
        fileBytes,
        filename: fileName,
      ));
      request.fields['instrument'] = _selectedInstrument.toLowerCase();

      var response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        print("변환 성공: $responseBody");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('MIDI 변환이 완료되었습니다.')),
        );
      } else {
        print("업로드 실패: ${response.reasonPhrase}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('업로드 실패: ${response.reasonPhrase}')),
        );
      }
    } catch (e) {
      print("업로드 및 변환 중 오류 발생: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('업로드 및 변환 중 오류 발생: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false; // 로딩 상태 해제
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          '악기를 선택하세요',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
            child: ElevatedButton(
              onPressed: _isLoading ? null : _pickFile, // 로딩 중에는 비활성화
              style: ElevatedButton.styleFrom(
                backgroundColor: _isLoading ? Colors.grey : Colors.green,
              ),
              child: _isLoading
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.0,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          '파일 변환 중...',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    )
                  : const Text(
                      '파일 선택 및 MIDI 변환',
                      style: TextStyle(color: Colors.white),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
