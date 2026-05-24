pipeline {
    agent { label 'app' }

    parameters {
        string(name: 'RDS_HOSTNAME', defaultValue: '', description: 'RDS endpoint')
        string(name: 'RDS_PORT', defaultValue: '3306', description: 'RDS port')
        string(name: 'REDIS_HOSTNAME', defaultValue: '', description: 'Redis endpoint')
        string(name: 'REDIS_PORT', defaultValue: '6379', description: 'Redis port')
        string(name: 'ALB_DNS', defaultValue: '', description: 'ALB DNS name')
        string(name: 'ENV', defaultValue: 'dev', description: 'Environment')
    }

    environment {
        APP_DIR    = '/home/ec2-user/app/nodeapp'
        APP_REPO   = 'https://github.com/mahmoud254/jenkins_nodejs_example.git'
        APP_BRANCH = 'rds_redis'
    }

    stages {

        stage('Clone App') {
            steps {

                sh """
                    rm -rf /home/ec2-user/app

                    git clone \
                      -b ${APP_BRANCH} \
                      ${APP_REPO} \
                      /home/ec2-user/app

                    echo "=== Files in nodeapp ==="

                    ls -la ${APP_DIR}
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

                        # Install pm2 locally under ec2-user
                        export PATH=\$PATH:/home/ec2-user/.local/bin

                        npm install -g pm2 --prefix /home/ec2-user/.npm-global

                        export PATH=\$PATH:/home/ec2-user/.npm-global/bin

                        pm2 stop app 2>/dev/null || true
                        pm2 delete app 2>/dev/null || true

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

        stage('Smoke Test via ALB') {
            steps {

                sh """
                    echo "=== Waiting for ALB health check to pass ==="
                    sleep 30

                    echo "=== Testing via ALB: ${params.ALB_DNS} ==="

                    DB_RESPONSE=\$(curl -s http://${params.ALB_DNS}/db)
                    REDIS_RESPONSE=\$(curl -s http://${params.ALB_DNS}/redis)

                    echo "DB response: \$DB_RESPONSE"
                    echo "Redis response: \$REDIS_RESPONSE"

                    echo "\$DB_RESPONSE" | grep -q "successful" \
                      && echo "✅ DB endpoint OK" \
                      || (echo "❌ DB endpoint FAILED" && exit 1)

                    echo "\$REDIS_RESPONSE" | grep -q "connected" \
                      && echo "✅ Redis endpoint OK" \
                      || (echo "❌ Redis endpoint FAILED" && exit 1)
                """
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