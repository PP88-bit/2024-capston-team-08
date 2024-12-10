import os
import subprocess
from flask import Flask, request, jsonify
from flask_cors import CORS
from basic_pitch.inference import predict_and_save, Model

app = Flask(__name__)
CORS(app)

UPLOAD_FOLDER = 'uploads'
OUTPUT_FOLDER = 'output'
MIDI_FOLDER = 'midi'
MODEL_PATH = r'C:\Users\82109\Desktop\2024-capston-team-08\basic-pitch\basic_pitch\saved_models\icassp_2022\nmp.onnx'

os.makedirs(UPLOAD_FOLDER, exist_ok=True)
os.makedirs(OUTPUT_FOLDER, exist_ok=True)
os.makedirs(MIDI_FOLDER, exist_ok=True)

@app.route('/upload', methods=['POST'])
def upload_file():
    if 'file' not in request.files or 'instrument' not in request.form:
        return jsonify({'error': 'File or instrument not provided'}), 400

    file = request.files['file']
    instrument = request.form['instrument']

    if file.filename == '':
        return jsonify({'error': 'No selected file'}), 400

    # Save uploaded file
    file_path = os.path.join(UPLOAD_FOLDER, file.filename)
    file.save(file_path)
    print(f"File saved to: {file_path}")

    file_path = os.path.normpath(file_path)
    output_path = os.path.normpath(OUTPUT_FOLDER)

    python_path = os.getenv('PYTHON_PATH', 'python')
    demucs_command = [
        python_path, '-m', 'demucs.separate',
        '-o', output_path, file_path,
        '-n', 'htdemucs_6s',
        '--mp3', '--mp3-bitrate', '320'
    ]

    try:
        print(f"Executing command: {' '.join(demucs_command)}")
        result = subprocess.run(demucs_command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        print(f"Demucs stdout: {result.stdout}")
        print(f"Demucs stderr: {result.stderr}")

        if result.returncode != 0:
            raise Exception(result.stderr)

        # Demucs 출력 디렉토리 구조 반영
        song_folder = os.path.splitext(file.filename)[0]
        demucs_output_path = os.path.join(output_path, "htdemucs_6s", song_folder)

        # 선택된 악기 매핑
        instrument_map = {
            'piano': 'piano',
            'guitar': 'guitar',
            'bass': 'bass',
            'drums': 'drum'
        }

        instrument_file = os.path.join(demucs_output_path, f"{instrument_map[instrument]}.mp3")
        print(f"Instrument file path: {instrument_file}")
        
        if not os.path.exists(instrument_file):
            print(f"Instrument file not found: {instrument_file}")
            return jsonify({'error': f"{instrument}.mp3 not found in {demucs_output_path}"}), 404

        # MIDI 변환
        midi_output_path = os.path.join(MIDI_FOLDER, f"{song_folder}_{instrument}.mid")
        print(f"Converting {instrument_file} to MIDI...")
        print(f"Using model path: {MODEL_PATH}")

        # Basic Pitch 모델 로드
        if not os.path.exists(MODEL_PATH):
            print(f"Model file not found: {MODEL_PATH}")
            return jsonify({'error': f"Model file not found: {MODEL_PATH}"}), 500

        try:
            model = Model(model_path=MODEL_PATH)
            print("Model successfully loaded.")

            # MIDI 변환 실행 (인수 수정)
            predict_and_save(
                [instrument_file],  # 파일 경로를 리스트로 전달
                MIDI_FOLDER,       # 출력 디렉토리
                save_midi=True,
                sonify_midi=False,
                save_model_outputs=False,
                save_notes=False,
                model_or_model_path=model,
            )

            print(f"MIDI file saved to: {midi_output_path}")

            return jsonify({'message': 'MIDI conversion successful!', 'midi_file': midi_output_path}), 200
        except Exception as midi_error:
            print(f"Error during MIDI conversion: {midi_error}")
            raise midi_error

    except Exception as e:
        import traceback
        print("Detailed Error Traceback:")
        traceback.print_exc()
        print(f"Error: {e}")
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True)
