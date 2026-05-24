pipeline {
    agent { label 'app' }

    parameters {
        string(name: 'RDS_HOSTNAME', defaultValue: '', description: 'RDS endpoint')
        string(name: 'RDS_PORT', defaultValue: '3306', description: 'RDS port')
        string(name: 'REDIS_HOSTNAME', defaultValue: '', description: 'Redis endpoint')
        string(name: 'REDIS_PORT', defaultValue: '6379', description: 'Redis port')
        string(name: 'ENV', defaultValue: 'dev', description: 'Environment')
    }

    environment {
        APP_DIR    = '/home/ec2-user/app'
        APP_REPO   = 'https://github.com/mahmoud254/jenkins_nodejs_example.git'
        APP_BRANCH = 'rds_redis'
    }

    stages {

        stage('Clone App') {
            steps {

                sh """
                    rm -rf ${APP_DIR}

                    git clone \
                      -b ${APP_BRANCH} \
                      ${APP_REPO} \
                      ${APP_DIR}
                """
            }
        }

        stage('Install Dependencies') {
            steps {

                dir("${APP_DIR}") {

                    sh 'npm install'
                }
            }
        }

        stage('Start App') {
            steps {

                withCredentials([
                    string(credentialsId: 'rds-password', variable: 'RDS_PASS')
                ]) {

                    sh """
                        echo "=== Config ==="

                        echo "RDS: ${params.RDS_HOSTNAME}:${params.RDS_PORT}"
                        echo "Redis: ${params.REDIS_HOSTNAME}:${params.REDIS_PORT}"

                        # Install pm2 if not present
                        npm list -g pm2 2>/dev/null || npm install -g pm2

                        # Stop existing app
                        pm2 stop app 2>/dev/null || true
                        pm2 delete app 2>/dev/null || true

                        # Start app with environment variables
                        RDS_HOSTNAME=${params.RDS_HOSTNAME} \\
                        RDS_USERNAME=bassant \\
                        RDS_PASSWORD=\$RDS_PASS \\
                        RDS_PORT=${params.RDS_PORT} \\
                        REDIS_HOSTNAME=${params.REDIS_HOSTNAME} \\
                        REDIS_PORT=${params.REDIS_PORT} \\
                        pm2 start ${APP_DIR}/app.js \\
                          --name app \\
                          --update-env

                        pm2 save
                        pm2 status

                        sleep 3

                        echo "=== Health Check ==="

                        curl -s http://localhost:3000/db
                        echo ""

                        curl -s http://localhost:3000/redis
                    """
                }
            }
        }
    }

    post {

        success {
            echo "✅ App deployed successfully for ${params.ENV}."
        }

        failure {
            echo "❌ App deployment failed."
        }
    }
}