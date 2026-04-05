pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "achrafacheche/portfolio"
        DOCKER_TAG = "v${BUILD_NUMBER}"
    }

    stages {
        stage('Clone') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/AchecheAchraf/portfolio-achraf.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-credentials',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh "echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin"
                    sh "docker push ${DOCKER_IMAGE}:${DOCKER_TAG}"
                }
            }
        }

        stage('Deploy') {
            steps {
                sh "docker stop portfolio || true"
                sh "docker rm portfolio || true"
                sh "docker run -d -p 80:80 --restart always --name portfolio ${DOCKER_IMAGE}:${DOCKER_TAG}"
            }
        }
    }
}
