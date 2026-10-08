pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'YOUR_DOCKERHUB_USERNAME/noticeboard:latest'
        DOCKER_CRED_ID = 'docker-hub-credentials' // Jenkins Credential ID for Docker Hub
        KUBE_CRED_ID = 'kube-config-credentials'   // Jenkins Credential ID for Kubeconfig
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
                    sh "docker build -t ${DOCKER_IMAGE} ."
                }
            }
        }
        stage('Push to Docker Hub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: DOCKER_CRED_ID, passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                        sh "echo \$DOCKER_PASSWORD | docker login -u \$DOCKER_USERNAME --password-stdin"
                        sh "docker push ${DOCKER_IMAGE}"
                    }
                }
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                withCredentials([file(credentialsId: KUBE_CRED_ID, variable: 'KUBECONFIG')]) {
                    sh "kubectl apply -f deployment.yaml --kubeconfig=\${KUBECONFIG}"
                }
            }
        }
    }
}
