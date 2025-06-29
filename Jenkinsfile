pipeline {
    agent any

    // Không cần biến PROJECT_ROOT_IN_REPO nữa vì Jenkinsfile đã nằm ở đúng "gốc" của ngữ cảnh mà chúng ta muốn
    environment {
        DOCKER_IMAGE_NAME = 'my-dotnet-app'
    }

    stages {
        stage('Checkout Source') {
            steps {
                // Jenkinsfile này được tải từ 'WebApplication1/Jenkinsfile'
                // Khi nó chạy, workspace của nó đã là 'C:\ProgramData\Jenkins\.jenkins\workspace\democicd\WebApplication1'
                // Vậy nên chỉ cần git clone "chính nó"
                // Hoặc có thể bỏ qua bước git này nếu Jenkins job đã tự clone
                // Giữ nguyên để đảm bảo nó ở đúng branch
                script {
                    // Lệnh 'git' mặc định của Jenkins sẽ checkout repo vào thư mục gốc của workspace.
                    // Nếu Jenkinsfile được cấu hình để đọc từ 'WebApplication1/Jenkinsfile',
                    // thì thư mục hiện tại khi pipeline bắt đầu đã là 'democicd/WebApplication1'.
                    // Do đó, chỉ cần đảm bảo mọi thứ được cập nhật.
                    // Bạn có thể không cần stage này nếu Jenkins đã làm điều đó ở bước đầu tiên.
                    // Tuy nhiên, để an toàn, có thể giữ lại để pull các thay đổi mới nhất vào đúng thư mục hiện tại.
                    git branch: 'main', url: 'https://github.com/ivy159205/democicd.git'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Tại đây, thư mục hiện tại (pwd()) đã là 'C:\ProgramData\Jenkins\.jenkins\workspace\democicd\WebApplication1'
                    // nơi Dockerfile và .csproj của bạn được nhìn thấy như ở "gốc"
                    echo "Building Docker image from directory: ${pwd()}"
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
                    sh "docker run -d --name ${env.DOCKER_IMAGE_NAME} -p 82:8080 ${env.DOCKER_IMAGE_NAME}:latest"

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