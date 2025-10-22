pipeline {
    agent { label 'debian-agent' }

    triggers {
        pollSCM('H/1 * * * *')
    }

    stages {
        stage('Preparar entorno') {
            steps {
                echo 'Iniciando pipeline...'
                sh 'docker --version'
            }
        }

        stage('Construir imagen Docker') {
            steps {
                echo 'Construyendo imagen Docker...'
                sh 'docker build -t miapp:latest .'
            }
        }

        stage('Desplegar contenedor') {
            steps {
                echo 'Desplegando contenedor...'
                sh '''
                    docker rm -f miapp || true
                    docker run -d -p 8080:80 --name miapp miapp:latest
                '''
            }
        }
    }

    post {
        success {
            echo 'Despliegue completado con éxito'
        }
        failure {
            echo 'Algo ha fallado en el pipeline'
        }
    }
}

