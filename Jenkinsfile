pipeline {
    agent any // Hoặc agent { label 'your-docker-agent' } nếu bạn có agent riêng có Docker

    environment {
        APP_DIR = 'WebApplication1/WebApplication1'
        DOCKER_IMAGE_NAME = 'my-dotnet-app'
    }

    stages {
        stage('Checkout Source') {
            steps {
                git branch: 'main', url: 'https://github.com/ivy159205/democicd.git' // Thay thế URL repo của bạn
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dir("${env.APP_DIR}") {
                        // Build Docker image với tag là tên image và latest
                        // Không cần số BUILD_NUMBER nếu chỉ triển khai cục bộ và luôn dùng latest
                        sh "docker build -t ${env.DOCKER_IMAGE_NAME}:latest ."
                    }
                }
            }
        }

        stage('Deploy to Localhost:82') {
            steps {
                script {
                    echo "Stopping and removing existing container (if any)..."
                    // Dừng và xóa container hiện có nếu nó đang chạy
                    sh "docker stop ${env.DOCKER_IMAGE_NAME} || true"
                    sh "docker rm ${env.DOCKER_IMAGE_NAME} || true"

                    echo "Running new Docker container on localhost:82..."
                    // Chạy container mới, ánh xạ cổng 80 của container sang cổng 82 của host
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