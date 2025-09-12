pipeline {
    agent any

    tools {
        maven 'Maven'       // الاسم اللي سجلته في Global Tool Config
        jdk 'JDK17'        // لازم يكون عندك JDK installation باسم Java17
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
                withSonarQubeEnv('SonarQube-Server') {   // 👈 هنا الاسم الجديد
                    sh '''
                        ${tool 'SonarScanner'}/bin/sonar-scanner \
                          -Dsonar.projectKey=spring-petclinic \
                          -Dsonar.sources=src \
                          -Dsonar.java.binaries=target
                    '''
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
