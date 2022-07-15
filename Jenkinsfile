pipeline {
    agent any
    tools {
        maven 'maven 3.8.6'
    }
    environment {
        imageName = "fleetman-api-gateway"
        registryCredentials = "nexus"
        registry = "nexus-registry.eastus.cloudapp.azure.com:8086/"
        dockerImage = ''
    }

    stages {

         stage('Clean Workspace') {
            steps {
                 cleanWs()
            }
         }

        stage('Get last commit ID') {
            steps {
                checkout scm
                sh 'git rev-parse --short HEAD > .git/commit-id'
                script {
                    commit_id = readFile('.git/commit-id').trim()
                }
            }
        }

        stage('Scan Code Quality') {
            steps {
                withSonarQubeEnv('sonarqubeIns') {
                  sh 'mvn clean package sonar:sonar'
                }
            }
        }

        stage("Quality Gate") {
            steps {
                timeout(time: 2, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage('Docker image build') {
            steps {
                 script {
                    dockerImage = docker.build imageName + ":${commit_id}"
                 }
            }
        }

        stage('Push Docker image to Nexus Registry') {
            steps {
                script {
                    docker.withRegistry( 'http://'+registry, registryCredentials) {
                        dockerImage.push()
                        dockerImage.push("latest")
                    }
                }
            }
        }

    }
}
