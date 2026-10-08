pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'monish1974/noticeboard:latest'
        DOCKER_CRED_ID = 'docker-hub-credentials'
        KUBE_CRED_ID = 'kube-config-credentials'
    }
    stages {
        stage('Clone Repository') {
            steps {
                checkout scm
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    bat "docker build -t ${DOCKER_IMAGE} ."
                }
            }
        }
        stage('Push to Docker Hub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: DOCKER_CRED_ID, passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                        // This command safely reads the secret password variable from Jenkins without exposing it or adding trailing spaces
                        bat "echo|set /p=\"%DOCKER_PASSWORD%\"|docker login -u %DOCKER_USERNAME% --password-stdin"
                        bat "docker push ${DOCKER_IMAGE}"
                    }
                }
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                withCredentials([file(credentialsId: KUBE_CRED_ID, variable: 'KUBECONFIG')]) {
                    bat "kubectl apply -f deployment.yaml --kubeconfig=\"%KUBECONFIG%\""
                }
            }
        }
    }
}
