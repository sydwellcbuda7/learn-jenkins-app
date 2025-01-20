pipeline {
    agent any

    environment{
        NETLIFY_SITE_ID = credentials('netlify-id')
        NETLIFY_AUTH_TOKEN = credentials('netlify-token')
        REACT_APP_VERSION = "1.2.$BUILD_ID"
    }

        stage('Build') {
            agent {
                docker {
                    image 'my-playwright'
                    reuseNode true
                }
            }

            steps {
                sh '''
                    npm ci
                    npm run build
                '''
            }
        }

        stage('Tests') {
            parallel {
                stage('Unit tests') {
                    agent {
                        docker {
                            image 'my-playwright'
                            reuseNode true
                        }
                    }

                    steps {
                        sh '''
                            test -f build/index.html
                            npm test
                        '''
                    }
                    post {
                        always {
                            junit 'jest-results/junit.xml'
                        }
                    }
                }

                stage('E2E') {
                    agent {
                        docker {
                            image 'my-playwright'
                            reuseNode true
                        }
                    }
                    steps {
                        sh '''
                            serve -s build &
                            sleep 10
                            npx playwright test  --reporter=html
                        '''
                    }

                    post {
                        always {
                            publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: false, reportDir: 'playwright-report', reportFiles: 'index.html', reportName: 'Local E2E', reportTitles: '', useWrapperFileDirectly: true])
                        }
                    }
                }
            }
        }

         stage('Deploy Stagging and E2E') {
            agent {
                docker {
                    image 'my-playwright'
                    reuseNode true
                }
            }
            environment{
                    CI_ENVIRONMENT_URL = 'STAGGING_URL_TO_BE_SET'
            }
             steps {
                sh '''
                    netlify deploy --dir=build --json > stagging-deploy-output.json
                    CI_ENVIRONMENT_URL=$(node-jq -r '.deploy_url'  stagging-deploy-output.json)
                    npx playwright test  --reporter=html
                '''
             }

             post {
                always {
                    publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: false, reportDir: 'playwright-report', reportFiles: 'index.html', reportName: 'Stagging E2E', reportTitles: '', useWrapperFileDirectly: true])
              }
             }
         }

         stage('Prod Deploy and E2E') {
            agent {
                docker {
                    image 'my-playwright'
                    reuseNode true
                }
            }
            environment{
                CI_ENVIRONMENT_URL = 'PROD_URL_TO_BE_SET'
            }
             steps {
                sh '''
                    netlify deploy --dir=build --prod --json > prod-deploy-output.json
                    CI_ENVIRONMENT_URL=$(node-jq -r '.url'  prod-deploy-output.json)
                    npx playwright test  --reporter=html
                '''
             }

             post {
               always {
                   publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: false, reportDir: 'playwright-report', reportFiles: 'index.html', reportName: 'Prod E2E', reportTitles: '', useWrapperFileDirectly: true])
              }
             }
         }
    }
}

