#!/bin/bash

#Set environmental variables
FILE_PATH="/home/ubuntu/start_app.sh"
REPO_PATH="/home/ubuntu/microblog_VPC_deployment"
SCRIPT_URL="https://raw.githubusercontent.com/cgordon-dev/microblog_VPC_deployment/refs/heads/main/scripts/start_app.sh"
START_SCRIPT="source $DOWNLOAD_PATH"

LOGIN_NAME="ubuntu"
SSH_KEY="/home/ubuntu/.ssh/id_rsa.pem"

APPLICATION_SERVER_IP="$APPLICATION_SERVER_IP"

echo "Begin SSH into the App Server..."

# SSH command to application server
ssh -i "$SSH_KEY" "$LOGIN_NAME@$APPLICATION_SERVER_IP" << EOF 2>/dev/null
if [[ -d "$REPO_PATH" ]] && [[ -f "$FILE_PATH" ]]; then
        echo "Repo and file already exist!"
        echo "Deleting existing local repo and file."
        rm -rf $REPO_PATH
        rm $FILE_PATH
        curl -L -o $FILE_PATH $SCRIPT_URL 2>/dev/null && chmod 755 $FILE_PATH && $START_SCRIPT
else
        curl -L -o $FILE_PATH $SCRIPT_URL 2>/dev/null && chmod 755 $FILE_PATH && $START_SCRIPT
fi
EOF       
