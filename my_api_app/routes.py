from flask import Flask, request, jsonify
import requests

app = Flask(__name__)

@app.route('/chat', methods=['POST'])
def chat():
    data = request.get_json()
    message = data.get('message')

    # OpenAI API와 통신하는 코드
    openai_url = ""
    headers = {
        "Content-Type": "application/json",
        "Authorization": "-"
    }
    payload = {
        "model": "gpt-3.5-turbo",
        "messages": [{"role": "user", "content": "You provide feedback to help users improve their playing based on their instrument and the accuracy of their playing. You always use polite sentences."
        }]
    }

    response = requests.post(openai_url, headers=headers, json=payload)
    result = response.json()

    return jsonify(result)
