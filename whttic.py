import json
from flask import Flask, request

app = Flask(__name__)

@app.route("/webhook", methods=["POST"])
def webhook():
    data = request.get_json()
    with open("tiktokdata.json", "w") as outfile:
        json.dump(data, outfile)
    return "Data saved to data.json"
