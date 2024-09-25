pipeline {
  agent any
    stages {
        stage ('Build') {
            steps {
                sh '''#!/bin/bash
                   python3.9 -m venv venv
                   source venv/bin/activate
                   pip install pip --upgrade
                   pip install -r requirements.txt
                   pip install gunicorn pymysql cryptography 
                   export FLASK_APP=microblog.py
                   flask translate compile
                   flask db upgrade
                '''
            }
        }
        stage ('Test') {
            steps {
                sh '''#!/bin/bash
                source venv/bin/activate
                export PYTHONPATH=$(pwd)
                py.test ./tests/unit/ --verbose --junit-xml test-reports/results.xml
                '''
            }
            post {
                always {
                    junit 'test-reports/results.xml'
                }
            }
        }
        stage('OWASP FS SCAN') {
            steps {
                dependencyCheck additionalArguments: '--scan ./ --disableYarnAudit --disableNodeAudit --nvdApiKey 46e883ba-2dff-4707-8813-5abacd3c29a2', odcInstallation: 'DP-Check'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }
      stage ('Clean') {
            steps {
                sh '''#!/bin/bash
                # Find the process ID of gunicorn using pgrep
                pid=$(pgrep -f "gunicorn")

                # Check if PID is found and is valid (non-empty)
                if [[ -n "$pid" && "$pid" -gt 0 ]]; then
                    echo "$pid" > pid.txt
                    kill $(cat pid.txt)
                    echo "Killed gunicorn process with PID $pid"
                else
                    echo "No gunicorn process found to kill"
                fi
                '''
            }
        }
      stage ('Deploy') {
            steps {
                sh '''#!/bin/bash
                #Jenkins server should run the setup script in the web server via SSH Tunneling
                ssh -i ~/.ssh/id_rsa.pem ubuntu@web-server-ip ./setup.sh
                
                '''
            }
        }
    }
}
