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
                    // Changed from sh to bat for Windows execution
                    bat "docker build -t ${DOCKER_IMAGE} ."
                }
            }
        }
        stage('Push to Docker Hub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: DOCKER_CRED_ID, passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                        // Updated to standard Windows batch environment variable formatting
                        bat "echo %DOCKER_PASSWORD% | docker login -u %DOCKER_USERNAME% --password-stdin"
                        bat "docker push ${DOCKER_IMAGE}"
                    }
                }
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                withCredentials([file(credentialsId: KUBE_CRED_ID, variable: 'KUBECONFIG')]) {
                    // Configured to map the file path properly on a Windows workspace
                    bat "kubectl apply -f deployment.yaml --kubeconfig=\"%KUBECONFIG%\""
                }
            }
        }
    }
}
