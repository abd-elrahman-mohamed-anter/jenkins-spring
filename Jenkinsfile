pipeline {
    agent any

    tools {
        maven 'Maven'       // الاسم اللي سجلته في Global Tool Config
        jdk 'JDK17'         // الاسم اللي سجلته في Global Tool Config
    }

    environment {
        // SONAR_AUTH_TOKEN ده اسم الـ Credential اللي خزّنته في Jenkins
        SONAR_AUTH_TOKEN = credentials('sonar-token')
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
                withSonarQubeEnv('SonarQube-Server') {   // الاسم في Configure System
                    sh "./mvnw sonar:sonar -Dsonar.login=${SONAR_AUTH_TOKEN}"
                }
            }
        }

        stage('Deploy with Docker Compose') {
            steps {
                sh 'docker-compose down || true'
                sh 'docker-compose up -d --build'
            }
        }
    }
}
