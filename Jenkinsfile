
pipeline {
    agent {
        node {
            label 'maven'
        }
    }
environment {
    PATH = "/opt/apache-maven-3.9.4/bin/:$PATH"
}
    stages {
        stage("build"){
            steps {
                sh 'mvn clean deploy '
            }
        }

    stage ('SonarQube analysis') {
    environment {
      SONAR_TOKEN = '17fa455017ede7b3c3f4b38f4200868a6a64d968'
      scannerHome = tool 'valaxy-sonar-scanner';  
    }
    steps{
    withSonarQubeEnv('valaxy-sonarqube-server') {
        sh "${scannerHome}/bin/sonar-scanner"
       }
       }
     }
}
}