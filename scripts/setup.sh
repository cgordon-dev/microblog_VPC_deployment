#!/bin/bash

# Variables
APP_SERVER_IP="10.0.2.110"
APP_SERVER_USER="ubuntu"  # Replace with the username of your application server
PRIVATE_KEY_PATH="~/.ssh/workload4.pem"  # Path to your SSH private key
START_SCRIPT_PATH="/home/ubuntu/start_app.sh"   # Path to start_app.sh on the app server

# SSH into the application server and run the existing start_app.sh script
ssh -i $PRIVATE_KEY_PATH $APP_SERVER_USER@$APP_SERVER_IP "bash $START_SCRIPT_PATH"

# Display a message indicating the script has run
echo "Successfully executed start_app.sh on the application server!"

