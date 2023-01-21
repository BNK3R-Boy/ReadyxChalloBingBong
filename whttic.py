import json
import os
from flask import Flask, request

app = Flask(__name__)

@app.route("/webhook", methods=["POST"])
def handle_webhook():
    data = request.get_json()
    with open("received_tt_data.json", "w") as json_file:
        json.dump(data, json_file)
    return "Data saved to JSON file"

if __name__ == "__main__":
    app.run(port=os.environ.get("PORT", 3000))
