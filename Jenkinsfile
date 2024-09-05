pipeline {
    agent any

    parameters {
        string(name: 'DOCKER_IMAGE', defaultValue: '', description: 'Docker Hub image URL (e.g., username/repository:tag)')
    }

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials')  // Docker Hub kimlik bilgileri
    }

    triggers {
        cron('H */12 * * *')  // 12 saatte bir çalışacak
    }

    stages {
        stage('Pull Docker Image') {
            steps {
                script {
                    if (!params.DOCKER_IMAGE?.trim()) {
                        error "Docker image URL is not provided. Please pass the Docker image from Docker Hub."
                    }
                    echo "Pulling Docker image: ${params.DOCKER_IMAGE}"
                    sh "docker pull ${params.DOCKER_IMAGE}"
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                script {
                    echo "Running Docker container from image: ${params.DOCKER_IMAGE}"
                    sh "docker run --rm --env-file /path/to/secrets.env ${params.DOCKER_IMAGE}"
                }
            }
        }
    }

    post {
        failure {
            mail to: 'you@example.com',  // Burada kullanıcı e-posta adresi verilmeli
                subject: "Jenkins Build Failed: ${env.JOB_NAME} [${env.BUILD_NUMBER}]",
                body: "The Jenkins job has failed. Please check the Jenkins console output for more details."
        }
        success {
            echo 'Build completed successfully.'
        }
    }
}
​⬤