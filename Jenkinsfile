pipeline {
    agent any

    tools {
        maven 'Maven'       // الاسم اللي سجلته في Global Tool Config
        jdk 'JDK17'         // الاسم اللي سجلته في Global Tool Config
    }

    environment {
        DOCKER_COMPOSE_DIR = "${WORKSPACE}"  // لو حابب تحدد مكان docker-compose.yml
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                sh './mvnw clean package -DskipTests'
            }
        }

        stage('Unit Tests') {
            steps {
                sh './mvnw test'
            }
            post {
                always {
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withCredentials([string(credentialsId: 'sonar-token1', variable: 'SONAR_TOKEN')]) {
                    sh """
                        mvn sonar:sonar \
                          -Dsonar.projectKey=spring-petclinic \
                          -Dsonar.sources=src/main/java \
                          -Dsonar.tests=src/test/java \
                          -Dsonar.java.binaries=target \
                          -Dsonar.host.url=http://localhost:9000 \
                          -Dsonar.login=$SONAR_TOKEN
                    """
                }
            }
        }

        stage('Deploy with Docker Compose') {
            steps {
                dir("${DOCKER_COMPOSE_DIR}") {
                    // استخدم Docker Compose V2
                    sh 'docker compose down || true'
                    sh 'docker compose up -d --build'
                }
            }
        }
    }

    post {
        failure {
            echo "Pipeline failed. Check the logs above for errors."
        }
        success {
            echo "Pipeline completed successfully!"
        }
    }
}
