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
                withAwsCli([credentialsId: 'aws-access', defaultRegion: 'us-west-2']) { 
                      aws cloudformation create-stack --stack-name capstoneudacity$UUID --template-body file://capstone_infra.yml \
                       --parameters file://capstone_infra_parameter.json --region=eu-west-2
                 }

                
            }
        }
    }
}