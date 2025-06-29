pipeline {
    agent any

    environment {
        // Đường dẫn tương đối từ thư mục gốc của Git repo đến thư mục chứa Dockerfile và Jenkinsfile
        PROJECT_ROOT_IN_REPO = 'WebApplication1'
        DOCKER_IMAGE_NAME = 'my-dotnet-app'
    }

    stages {
        stage('Checkout Source') {
            steps {
                // Jenkins sẽ checkout toàn bộ repo vào workspace của job
                git branch: 'main', url: 'https://github.com/ivy159205/democicd.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Chuyển vào thư mục chứa Dockerfile và các file dự án (tức là PROJECT_ROOT_IN_REPO)
                    dir("${env.PROJECT_ROOT_IN_REPO}") {
                        echo "Building Docker image from directory: ${pwd()}"
                        // Lệnh docker build được chạy từ thư mục hiện tại (democicd/WebApplication1)
                        // "." (context) sẽ là thư mục đó, Dockerfile cũng nằm ở đó
                        sh "docker build -t ${env.DOCKER_IMAGE_NAME}:latest ."
                    }
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