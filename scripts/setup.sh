#!/bin/bash

# Set environmental variables
FILE_PATH="/home/ubuntu/start_app.sh"
REPO_PATH="/home/ubuntu/microblog_VPC_deployment"
SCRIPT_URL="https://raw.githubusercontent.com/cgordon-dev/microblog_VPC_deployment/refs/heads/main/scripts/start_app.sh"
START_SCRIPT="source $FILE_PATH"  # Fixed DOWNLOAD_PATH issue

LOGIN_NAME="ubuntu"
SSH_KEY="/home/ubuntu/.ssh/id_rsa.pem"

APPLICATION_SERVER_IP=$1

# Check if the application server IP is provided
if [ -z "$APPLICATION_SERVER_IP" ]; then
    echo "Error: Application server IP not provided."
    exit 1
fi

echo "Begin SSH into the App Server..."

# SSH command to application server
ssh -i "$SSH_KEY" "$LOGIN_NAME@$APPLICATION_SERVER_IP" << EOF
    if [[ -d "$REPO_PATH" ]] && [[ -f "$FILE_PATH" ]]; then
        echo "Repo and file already exist!"
        echo "Deleting existing local repo and file."
        rm -rf $REPO_PATH  # Consider whether deleting the whole repo is necessary
        rm $FILE_PATH
        curl -L -o $FILE_PATH $SCRIPT_URL && chmod 755 $FILE_PATH && $START_SCRIPT
    else
        curl -L -o $FILE_PATH $SCRIPT_URL && chmod 755 $FILE_PATH && $START_SCRIPT
    fi
EOF

# Optional: Add error handling for the SSH command if needed
if [ $? -ne 0 ]; then
    echo "Error: SSH command failed"
    exit 1
fi
