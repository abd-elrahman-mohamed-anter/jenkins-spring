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
                git branch: 'main', url: 'https://github.com/abd-elrahman-mohamed-anter/spring-petclinic-fork'
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

        stage('Upload to Nexus') {
            steps {
                script {
                    // ياخد أول JAR اتبني في target/ (مش النسخة original)
                    def jarFile = sh(script: "ls target/*.jar | grep -v original | head -n 1 || true", returnStdout: true).trim()

                    if (!jarFile) {
                        error "No JAR file found in target/ directory. Skipping Nexus upload."
                    }

                    echo "Found JAR: ${jarFile}, uploading to Nexus..."

                    withCredentials([usernamePassword(credentialsId: 'nexus-credentials',
                                                     usernameVariable: 'NEXUS_USER',
                                                     passwordVariable: 'NEXUS_PASS')]) {
                        sh """
                            mvn deploy:deploy-file \
                              -DgroupId=com.example \
                              -DartifactId=petclinic \
                              -Dversion=1.0.0 \
                              -Dpackaging=jar \
                              -Dfile=${jarFile} \
                              -DrepositoryId=nexus \
                              -Durl=http://localhost:8081/repository/maven-releases1/ \
                              -Dusername=\\\$NEXUS_USER \
                              -Dpassword=\\\$NEXUS_PASS
                        """
                    }
                }
            }
        }
    }
}
