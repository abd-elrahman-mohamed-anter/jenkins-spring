pipeline {
    agent any

    tools {
        maven "Maven3"   // اتأكد انك ضايف Maven باسم Maven3 من Global Tool Configuration
        jdk "JDK17"      // نفس الفكرة JDK17
    }

    environment {
        SONARQUBE = "SonarQube-Server"   // الاسم اللي سجلته في SonarQube installations
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
                withCredentials([usernamePassword(credentialsId: 'nexus-credentials',
                                                 usernameVariable: 'NEXUS_USER',
                                                 passwordVariable: 'NEXUS_PASS')]) {
                    sh """
                        mvn deploy:deploy-file \
                          -DgroupId=com.example \
                          -DartifactId=petclinic \
                          -Dversion=1.0.0 \
                          -Dpackaging=jar \
                          -Dfile=target/spring-petclinic-3.2.0-SNAPSHOT.jar \
                          -DrepositoryId=nexus \
                          -Durl=http://localhost:8081/repository/maven-releases/ \
                          -Dusername=$NEXUS_USER \
                          -Dpassword=$NEXUS_PASS
                    """
                }
            }
        }
    }
}
