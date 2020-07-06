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
					sh '''
						docker build -t yamini91/capstone .
					'''				
			}
		}

		stage('Push Image To Dockerhub') {
			steps {
					sh '''
						docker login --username $USER_CREDENTIALS_USR --password $USER_CREDENTIALS_PSW
                        docker tag capstone yamini91/capstone:latest
						docker push yamini91/capstone:latest
					'''
			}
			
		}

		stage('Set current kubectl context') {
			steps {
				withAWS(region:'us-west-2', credentials:'aws-access') {
					sh '''
						kubectl config use-context arn:aws:eks:us-west-2:522489204104:cluster/capstonecluster
					'''
				}
			}
		}

		stage('Deploy blue container') {
			steps {
				withAWS(region:'us-west-2', credentials:'aws-access') {
					sh '''
						kubectl apply -f ./blue-controller.json
					'''
				}
			}
		}

		stage('Deploy green container') {
			steps {
				withAWS(region:'us-west-2', credentials:'aws-access') {
					sh '''
						kubectl apply -f ./green-controller.json
					'''
				}
			}
		}

		stage('Create the service in the cluster, redirect to blue') {
			steps {
				withAWS(region:'us-west-2', credentials:'aws-access') {
					sh '''
						kubectl apply -f ./blue-service.json
					'''
				}
			}
		}

		stage('Wait user approve') {
            steps {
                input "Ready to redirect traffic to green?"
            }
        }

		stage('Create the service in the cluster, redirect to green') {
			steps {
				withAWS(region:'us-west-2', credentials:'aws-access') {
					sh '''
						kubectl apply -f ./green-service.json
					'''
				}
			}
		}

	}
}