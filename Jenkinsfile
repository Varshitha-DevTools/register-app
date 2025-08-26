pipeline {
    agent { label 'agent1' }
    tools {
        jdk 'Java17'
        maven 'Maven3'
    }
    environment {
	    APP_NAME = "register-app-pipeline"
            RELEASE = "1.0.0"
            DOCKER_CREDENTIALS = credentials("dockerhub-creds")
            IMAGE_NAME = "${DOCKER_CREDENTIALS_USR}" + "/" + "${APP_NAME}"
            IMAGE_TAG = "${RELEASE}-${BUILD_NUMBER}"
            JENKINS_API_TOKEN = credentials("JENKINS_API_TOKEN")
            AWS_ACCOUNT_ID = '807860707312'      // Replace with your AWS account 
            AWS_REGION = 'us-east-1'             // Replace with your AWS region
            ECR_REPO = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/register-app-repo"
            SONAR_TOKEN= 'ccda7df318392613d3a4425fcccb7dc7256cfb49'
            
    }
    stages{
        stage("Cleanup Workspace"){
                steps {
                cleanWs()
                }
        }

        stage("Checkout from SCM"){
                steps {
                    git branch: 'main', credentialsId: 'Org', url: 'https://github.com/Varshitha-DevTools/register-app.git'
                }
        }

        stage("Build Application"){
            steps {
                sh "mvn clean package"
            }

       }

       stage("Testing Application"){
           steps {
                 sh "mvn test"
           }
       }

       stage('SonarCloud Scan') {
            steps {
                withCredentials([string(credentialsId: 'sonarcloud-token', variable: 'SONAR_TOKEN')]) {
                    sh """
                        sonar-scanner \\
                            -Dsonar.projectKey=game-app_demo-app \\
                            -Dsonar.organization=game-app \\
                            -Dsonar.token=$SONAR_TOKEN \\
                            -Dsonar.sources=. \\
                            -Dsonar.host.url=https://sonarcloud.io
                    """
                }
            }
        }



       stage("Quality Gate"){
           steps {
               script {
                    waitForQualityGate abortPipeline: false, credentialsId: 'SonarToken'
                }	
            }

        }

        stage("Build & Push Docker Image") {
            steps {
                script {
                    docker.withRegistry('','dockerhub-creds') {
                        docker_image = docker.build "${IMAGE_NAME}"
                    }

                    docker.withRegistry('','dockerhub-creds') {
                        docker_image.push("${IMAGE_TAG}")
                        docker_image.push('latest')
                    }
                }
            }

       }

        stage("Push to AWS ECR") {
            steps {
                script {
                    // Authenticate with ECR
                    sh """
                        aws ecr get-login-password --region ${AWS_REGION} \
                        | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
                    """

                    // Tag Docker image for ECR
                    sh "docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${ECR_REPO}:${IMAGE_TAG}"
                    sh "docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${ECR_REPO}:latest"

                    // Push image to ECR
                    sh "docker push ${ECR_REPO}:${IMAGE_TAG}"
                    sh "docker push ${ECR_REPO}:latest"
                }
            }
        }    

       stage("Trivy Scan") {
           steps {
               script {
	            sh ('docker run -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy image ashfaque9x/register-app-pipeline:latest --no-progress --scanners vuln  --exit-code 0 --severity HIGH,CRITICAL --format table')
               }
           }
       }

       stage ('Cleanup Artifacts') {
           steps {
               script {
                    sh "docker rmi ${IMAGE_NAME}:${IMAGE_TAG}"
                    sh "docker rmi ${IMAGE_NAME}:latest"
               }
          }
       }

       stage("Trigger CD Pipeline") {
            steps {
                script {
                    sh "curl -v -k --user admin:${JENKINS_API_TOKEN} -X POST -H 'cache-control: no-cache' -H 'content-type: application/x-www-form-urlencoded' --data 'IMAGE_TAG=${IMAGE_TAG}' '48.214.144.64:8080/job/Deployment/buildWithParameters?token=gitops-token'"
                }
            }
       }
    }

     post {
    failure {
    emailext (
        body: """
            <h3>Build Failed</h3>
            <p>Job: ${env.JOB_NAME}</p>
            <p>Build Number: ${env.BUILD_NUMBER}</p>
            <p>Status: FAILURE</p>
        """,
        subject: "${env.JOB_NAME} - Build #${env.BUILD_NUMBER} - Failed",
        mimeType: 'text/html',
        to: "varshithag@devtools.in"
    )


        // Create GitHub Issue
        script {
            withCredentials([string(credentialsId: 'GitHub', variable: 'GITHUB_TOKEN')]) {
                def repoOwner = 'Varshitha-DevTools'   
                def repoName = 'register-app'                 
                def issueTitle = "Jenkins Build Failed: ${env.JOB_NAME} #${env.BUILD_NUMBER}"
                def issueBody = """\
                    Build URL: ${env.BUILD_URL}
                    Job: ${env.JOB_NAME}
                    Build Number: ${env.BUILD_NUMBER}
                    Result: FAILURE
                    Please check the Jenkins console output for details.
                    """.stripIndent()

                def jsonPayload = groovy.json.JsonOutput.toJson([
                    title: issueTitle,
                    body: issueBody
                ])

                // Use single quotes and shell variable to avoid secret leakage in logs
                sh """
                curl -s -H "Authorization: token \$GITHUB_TOKEN" \\
                     -H "Accept: application/vnd.github.v3+json" \\
                     -X POST \\
                     -d '${jsonPayload}' \\
                     https://api.github.com/repos/${repoOwner}/${repoName}/issues
                """
            }
        }    
    }
    
    success {
    emailext (
        body: "Job: ${env.JOB_NAME}\nBuild Number: ${env.BUILD_NUMBER}\nStatus: SUCCESS",
        subject: "${env.JOB_NAME} - Build #${env.BUILD_NUMBER} - Successful",
        to: "varshithag@devtools.in"
    )
}
}
}
