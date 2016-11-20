import os
from flask import Flask, jsonify, request
from faker import Factory
from twilio.access_token import AccessToken, IpMessagingGrant

app = Flask(__name__)
fake = Factory.create()

@app.route('/')
def index():
    return app.send_static_file('index.html')

@app.route('/channel/numbers/<phone_number>', methods=['GET'])
def channel_add_number(phone_number=None):
    return phone_number

@app.route('/token')
def token():
    # get credentials for environment variables
    account_sid = 'AC5138679cdee085ee4d8cfd8ea4e2e6c3'
    api_key = 'SKaf7bebe598236ea73290882b685cbe4f'
    api_secret = 'B22mFMUv1sC8hAgZo8dzQBxMl2eIYg1L'
    service_sid = 'ISd08e78b23fea4c59a94ea1ffb3651ef7'

    # create a randomly generated username for the client
    identity = fake.user_name()

    # Create a unique endpoint ID for the 
    device_id = request.args.get('device')
    endpoint = "TwilioChatDemo:{0}:{1}".format(identity, device_id)

    # Create access token with credentials
    token = AccessToken(account_sid, api_key, api_secret, identity)

    # Create an IP Messaging grant and add to token
    ipm_grant = IpMessagingGrant(endpoint_id=endpoint, service_sid=service_sid)
    token.add_grant(ipm_grant)

    # Return token info as JSON
    return jsonify(identity=identity, token=token.to_jwt())

if __name__ == '__main__':
    app.run(debug=True)
