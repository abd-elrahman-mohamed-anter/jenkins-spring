pipeline {
    agent any

    tools {
        maven "Maven3"
        jdk "JDK17"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/abd-elrahman-mohamed-anter/spring-petclinic-fork'
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }

        stage('Health Check') {
            steps {
                script {
                    echo "🩺 Checking Spring Boot Health Endpoint..."
                    sh """
                        STATUS=\$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/actuator/health || true)
                        if [ "\$STATUS" != "200" ]; then
                          echo "❌ Health endpoint is not OK!"
                          exit 1
                        else
                          echo "✅ Health endpoint is healthy"
                        fi
                    """
                }
            }
        }

        stage('Observability Check') {
            steps {
                script {
                    echo "🔍 Checking Prometheus metrics endpoint..."
                    sh """
                        STATUS=\$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/actuator/prometheus || true)
                        if [ "\$STATUS" != "200" ]; then
                          echo "❌ Prometheus endpoint not available!"
                          exit 1
                        else
                          echo "✅ Prometheus endpoint is healthy"
                        fi
                    """
                }
            }
        }
    }
}
