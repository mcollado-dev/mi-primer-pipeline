pipeline {
    agent { label 'debian-agent' }

    environment {
        DEPLOY_USER = 'manuelcollado'
        DEPLOY_HOST = '192.168.56.102'
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Clonando repositorio...'
                checkout scm
            }
        }

        stage('SonarQube Analysis') {
            steps {
                echo 'Ejecutando análisis SonarQube...'
                // El nombre aquí debe coincidir con tu instalación de SonarQube en Configure System
                withSonarQubeEnv('SonarQube-Local') {
                    // Usamos la herramienta SonarScanner gestionada por Jenkins
                    def scannerHome = tool name: 'SonarScanner', type: 'hudson.plugins.sonar.SonarRunnerInstallation'
                    sh """
                        ${scannerHome}/bin/sonar-scanner \
                            -Dsonar.projectKey=miapp \
                            -Dsonar.sources=. \
                            -Dsonar.host.url=${SONAR_HOST_URL} \
                            -Dsonar.login=${SONAR_AUTH_TOKEN}
                    """
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Construyendo imagen Docker...'
                sh '''
                    docker rm -f miapp || true
                    docker rmi -f miapp:latest || true
                    docker builder prune -af || true
                    docker build --no-cache -t miapp:latest .
                '''
            }
        }

        stage('Deploy to DebianMiApp') {
            steps {
                echo 'Desplegando en DebianMiApp...'
                sh '''
                    echo "==> Verificando conexión SSH..."
                    ssh -o StrictHostKeyChecking=no ${DEPLOY_USER}@${DEPLOY_HOST} "echo 'Conexión SSH correcta'"

                    echo "==> Enviando imagen Docker..."
                    docker save miapp:latest | bzip2 | ssh -o StrictHostKeyChecking=no ${DEPLOY_USER}@${DEPLOY_HOST} 'bunzip2 | docker load'

                    echo "==> Lanzando contenedor remoto..."
                    ssh -o StrictHostKeyChecking=no ${DEPLOY_USER}@${DEPLOY_HOST} <<'EOF'
docker rm -f miapp || true
docker run -d -p 8080:80 --name miapp miapp:latest
EOF
                '''
            }
        }

        stage('Quality Gate') {
            steps {
                echo 'Esperando resultado del Quality Gate...'
                timeout(time: 5, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline completado correctamente: análisis, build y despliegue exitosos.'
        }
        failure {
            echo 'Falló el pipeline. Revisa el log en Jenkins.'
        }
    }
}
