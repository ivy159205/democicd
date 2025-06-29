pipeline {
    agent any

    environment {
        // APP_DIR = 'WebApplication1/WebApplication1' // Không cần nữa vì Dockerfile ở gốc và context là gốc
        DOCKER_IMAGE_NAME = 'my-dotnet-app'
    }

    stages {
        stage('Checkout Source') {
            steps {
                git branch: 'main', url: 'https://github.com/ivy159205/democicd.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Lệnh docker build được chạy từ thư mục gốc của workspace Jenkins
                    // nơi Jenkinsfile và Dockerfile của bạn đang nằm.
                    // Dấu chấm "." chỉ ra context là thư mục hiện tại (tức là democicd/)
                    sh "docker build -t ${env.DOCKER_IMAGE_NAME}:latest ."
                }
            }
        }

        stage('Deploy to Localhost:82') {
            steps {
                script {
                    echo "Stopping and removing existing container (if any)..."
                    sh "docker stop ${env.DOCKER_IMAGE_NAME} || true"
                    sh "docker rm ${env.DOCKER_IMAGE_NAME} || true"

                    echo "Running new Docker container on localhost:82..."
                    sh "docker run -d --name ${env.DOCKER_IMAGE_NAME} -p 82:80 ${env.DOCKER_IMAGE_NAME}:latest"

                    echo "Application should now be accessible at http://localhost:82"
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
        success {
            echo 'Pipeline completed successfully! Application is deployed to localhost:82'
        }
        failure {
            echo 'Pipeline failed! Check logs for details.'
        }
    }
}