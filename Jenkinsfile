pipeline {
    agent { label 'debian-agent' }

    stages {
        stage('Esperar webhook') {
            steps {
                script {
                    // Registrar un webhook temporal
                    def hook = registerWebhook()
                    echo "Esperando POST en ${hook.url}"
                    
                    // Espera hasta que se reciba un POST en esa URL
                    def data = waitForWebhook(hook)
                    echo "Webhook recibido con datos: ${data}"
                }
            }
        }

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
