pipeline {
    agent any

    stages {
        stage('Preparar entorno') {
            steps {
                echo 'Iniciando pipeline...'
            }
        }

        stage('Construir imagen Docker') {
            steps {
                sh 'docker build -t miapp:latest .'
            }
        }

        stage('Ejecutar contenedor') {
            steps {
                sh 'docker run -d --name miapp -p 8081:8080 miapp:latest || echo "Contenedor ya existe"'
            }
        }
    }

    post {
        always {
            echo 'Pipeline finalizado.'
        }
    }
}
