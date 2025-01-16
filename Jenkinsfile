pipeline {
    agent any

    stages {
        stage('docker') {
            agent {
                docker {
                    image 'node:18-alpine'
                }
            }
            steps {
                echo 'Hello Docker'
            }
        }
    }
}
