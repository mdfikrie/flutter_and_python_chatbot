from flask import Flask, request, jsonify
from chatterbot import ChatBot
from chatterbot.trainers import ListTrainer, ChatterBotCorpusTrainer
from flask_cors import CORS
import requests

# initialize flask
app = Flask(__name__)
CORS(app)

# create instance chatbot
bot = ChatBot("Mauju", logic_adapters=[
    {
        'import_path':'chatterbot.logic.BestMatch',
        'default_response':'Sorry I do not have an answer!',
        'maximum_similarity_threshold':0.9
    }
])

# list_to_train = [
#     "hi",
#     "hi mate!",
#     "buatkan invoice",
#     "Tentu, saya akan membuatkan anda invoice! Silahkan pilih client dulu..",
#     "buatkan new invoice",
#     "Tentu, saya akan membuatkan anda invoice! Silahkan pilih client dulu..",
#     "buatkan invoice baru",
#     "Tentu, saya akan membuatkan anda invoice! Silahkan pilih client dulu..",
#     "buatkan faktur baru",
#     "Tentu, saya akan membuatkan anda invoice! Silahkan pilih client dulu..",
#     "buatkan tagihan baru",
#     "Tentu, saya akan membuatkan anda invoice! Silahkan pilih client dulu..",
# ]

# trainer = ListTrainer(bot)
# trainer.train(list_to_train)

trainer = ChatterBotCorpusTrainer(bot)
trainer.train("chatterbot.corpus.english")


@app.route("/chat", methods=["POST"])
def chat():
    # get message from request
    user_message = request.json.get("message")
    # get response from bot
    bot_response = bot.get_response(user_message)
    return jsonify({"response":str(bot_response)})

@app.route("/train", methods=["POST"])
def train():
    train_message = request.json.get("training_data")
    trainer = ListTrainer(bot)
    trainer.train(train_message)
    return jsonify({"message":"Training data has been added successfully!"})

# running flask server
if __name__ == "__main__":
    app.run(debug=True)
