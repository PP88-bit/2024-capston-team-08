import os
import subprocess
from flask import Flask, request, jsonify
from flask_cors import CORS  # CORS 지원 추가

app = Flask(__name__)
CORS(app)  # 모든 도메인에 대해 CORS 활성화
UPLOAD_FOLDER = 'uploads'
OUTPUT_FOLDER = 'output'

@app.route('/upload', methods=['POST'])
def upload_file():
    if 'file' not in request.files:
        return jsonify({'error': 'No file part'}), 400

    file = request.files['file']
    if file.filename == '':
        return jsonify({'error': 'No selected file'}), 400

    # Ensure the upload folder exists
    if not os.path.exists(UPLOAD_FOLDER):
        os.makedirs(UPLOAD_FOLDER)

    # Get the original file name and save the file
    original_filename = file.filename
    file_path = os.path.join(UPLOAD_FOLDER, original_filename)
    file.save(file_path)
    print(f"File saved to: {file_path}")

    # Convert Windows path to Unix-style path for subprocess
    file_path = file_path.replace("\\", "/")
    output_path = OUTPUT_FOLDER.replace("\\", "/")

    # Path to the correct Python environment's interpreter
    python_path = r'C:\Users\82109\AppData\Local\Programs\Python\Python39\python.exe'  # Update this path if necessary

    # Construct the demucs command to separate 6 sources (vocals, bass, drums, guitar, piano, other)
    demucs_command = [
        python_path, '-m', 'demucs.separate',
        '-o', output_path, file_path,
        '-n', 'htdemucs_6s',  # Use the 6-source model
        '--mp3',
        '--mp3-bitrate', '320'
    ]

    print(f"Executing command: {' '.join(demucs_command)}")

    # Execute the demucs command
    try:
        result = subprocess.run(demucs_command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)

        # Log stdout and stderr
        print(f"Demucs output: {result.stdout}")
        print(f"Demucs error: {result.stderr}")

        if result.returncode != 0:
            raise Exception(f"Demucs error: {result.stderr}")

        return jsonify({'message': 'File processed successfully!'}), 200
    except Exception as e:
        print(f"Error: {e}")
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True)
