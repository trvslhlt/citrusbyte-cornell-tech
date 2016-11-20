import os
from flask import Flask, jsonify, request
from faker import Factory
from pymessenger.bot import Bot

app = Flask(__name__)
fake = Factory.create()

@app.route('/')
def index():
    bot = Bot('EAAS88137Gj8BAKYmBVKFkqAZB7M9ZCcC5KKSgs88nxcae42btoKnCd7mevZBgezQM5lQkFjyoIYoCoC84hivjo8UK15m1W3gmaZCkxFGZCpm8bywt5tAhOP34Y2q4qlst0IsgzRQ8Uj0PtnXDke6gotQxO81UOj1WKNrvXS6LEgZDZD')
    bot.send_text_message('12812070', "test message")
    return 'we tried'

if __name__ == '__main__':
    app.run(debug=True)
