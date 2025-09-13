pipeline {
    agent any

    tools {
        maven 'Maven'       // الاسم اللي سجلته في Global Tool Config
        jdk 'JDK17'         // الاسم اللي سجلته في Global Tool Config
    }

    environment {
        DOCKER_COMPOSE_DIR = "${WORKSPACE}"  // مكان docker-compose.yml
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                // نعمل Skip للاختبارات في الـ Build
                sh './mvnw clean package -DskipTests -Dmaven.test.failure.ignore=true'
            }
        }

        stage('Start PostgreSQL') {
            steps {
                dir("${DOCKER_COMPOSE_DIR}") {
                    sh 'docker compose up -d postgres'
                }
                // ندي PostgreSQL وقت يجهز
                sh 'sleep 15'
            }
        }

        stage('Unit Tests') {
            steps {
                // || true عشان الـ Pipeline يكمل حتى لو حصل Fail
                sh './mvnw test || true'
            }
            post {
                always {
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }

        stage('Deploy All Services') {
            steps {
                dir("${DOCKER_COMPOSE_DIR}") {
                    // نشغل بقية الخدمات (PetClinic + Prometheus + Grafana + SonarQube)
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
