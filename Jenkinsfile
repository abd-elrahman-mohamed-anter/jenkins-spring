pipeline {
    agent any

    tools {
        maven "Maven3"
        jdk "JDK17"
    }

    environment {
        SONARQUBE = "SonarQube-Server"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/abd-elrahman-mohamed-anter/jenkins-spring'
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube-Server') {
                    sh 'mvn sonar:sonar'
                }
            }
        }

        stage('Docker Compose Up') {
            steps {
                sh 'docker compose -f docker-compose.yml up -d --build'
            }
        }

        stage('Health Check') {
            steps {
                script {
                    // PetClinic
                    sh 'for i in {1..30}; do curl -fs http://localhost:8890/actuator/health && break || sleep 5; done'

                    // Prometheus
                    sh 'for i in {1..30}; do curl -fs http://localhost:9090/-/ready && break || sleep 5; done'

                    // Grafana
                    sh 'for i in {1..30}; do curl -fs http://localhost:3000/api/health && break || sleep 5; done'
                }
            }
        }
    }
}
