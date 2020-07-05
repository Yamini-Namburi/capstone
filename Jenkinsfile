pipeline {
    environment {
        USER_CREDENTIALS = credentials('dockerhub')
    }
    agent any
    stages {
        stage('Lint HTML') {
            steps {
                sh 'tidy -q -e *.html'
            }
        }
        stage('Build Docker Image') {
            steps {
                sh './run_docker.sh'
            }
        }
        stage('Push to Docker Hub') {
            steps {
                sh 'echo Username ----- $USER_CREDENTIALS_USR , pwd ----- $USER_CREDENTIALS_PSW'
                sh './upload_docker.sh $USER_CREDENTIALS_USR $USER_CREDENTIALS_PSW'
            }
        }
        stage('Deploy') {
            steps {
                withAWS(credentials:'aws-access') {
                  sh 'aws cloudformation create-stack --stack-name capstoneudacity --template-body file://network-server.yml \
                      --capabilities CAPABILITY_NAMED_IAM --parameters file://network-server-params.json --region=eu-west-2'
                }                
            }
        }
    }
}