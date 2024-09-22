#!/bin/bash

# Update and install necessary packages
sudo apt install python3-pip python3.9 python3.9-venv -y
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt install software-properties-common -y
sudo apt install nginx -y
sudo apt install git -y


# Clone the GitHub repository
git clone https://github.com/cgordon-dev/microblog_VPC_deployment.git
cd /home/ubuntu/microblog_VPC_deployment

# Set up a Python virtual environment
python3.9 -m venv venv && source venv/bin/activate

# Install application dependencies from requirements.txt
pip install -r requirements.txt

# Install additional dependencies
pip install gunicorn pymysql cryptography

# Set environment variables
export FLASK_APP=microblog.py


# Run Flask commands (optional)
flask translate compile
flask db upgrade  

# Start the application using Gunicorn in the background
gunicorn -b :5000 -w 4 microblog:app --daemon

# Display a message indicating the server is running
echo "Application server started with Gunicorn!"
