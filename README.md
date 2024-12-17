# Used open source
Demucs https://github.com/facebookresearch/demucs <br> 
Basic Pitch https://github.com/spotify/basic-pitch

<br><br>

# How to build
## 컴퓨터에서 실행할 경우
app.py를 먼저 실행하고, lib\main.dart를 실행한다.



## 모바일 앱으로 실행하는 경우(Android Only)
apk 파일을 다운로드한 후 실행한다.

<br><br>

# How to Install 
## 설치 조건
python 3.9 



##  설치 방법
Python, ffmpeg를 환경 변수에 추가한다.
firebase를 다운하여 디렉토리에 설치한다.

cmd를 켜 다음 코드를 입력한다. 

```
pip install demucs #Demuccs 설치

pip install pasic-pitch #Basic Pitch 설치

pip install pytorch #pytorch 설치
```

이후, app.py의 13번째 줄에 있는 MODEL_PATH를 basic pitch의 폴더 내에 있는 nmp.onnx의 경로로 수정하고,
chatbotfeedback.dart의 api 링크를 유효한 것으로 수정한다.
```
MODEL_PATH = r'your_path\nmp.onnx' #디렉토리 내의 경로로 수정
```

<br><br>

# How to test
화면을 클릭하여 로그인, 챗봇, 파일 변환 기능이 정상적으로 작동하는지 확인한다.
