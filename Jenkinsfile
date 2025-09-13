pipeline {
    agent any

    tools {
        maven 'Maven'       // الاسم اللي سجلته في Global Tool Config
        jdk 'JDK17'         // الاسم اللي سجلته في Global Tool Config
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
                withCredentials([string(credentialsId: 'sonar-token', variable: 'SONAR_TOKEN')]) {
                    sh """
                        ${tool 'SonarScanner'}/bin/sonar-scanner \
                          -Dsonar.projectKey=spring-petclinic \
                          -Dsonar.sources=src \
                          -Dsonar.java.binaries=target \
                          -Dsonar.login=$SONAR_TOKEN
                    """
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
