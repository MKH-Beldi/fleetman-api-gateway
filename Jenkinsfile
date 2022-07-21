pipeline {
    agent any
    tools {
        maven 'maven 3.8.6'
    }
    environment {
        imageName = "fleetman-api-gateway"
        registryCredentials = "nexus"
        registry = ''
        dockerImage = ''
    stages {

        stage('Git Preparation') {
            steps {
                cleanWs()
                checkout scm
                sh 'git rev-parse --short HEAD > .git/commit-id'
                script {
                    commit_id = readFile('.git/commit-id').trim()
                }
                sh 'chmod 775 *'
                sh 'echo ${registry}'
            }
        }

        stage('JUnit Test') {
            steps {
                  sh './mvnw test'
            }
        }

        stage('Build Jar') {
            steps {
                sh './mvnw package'
            }
        }

        stage('SonarQube Scan Code Quality') {
            steps {
                withSonarQubeEnv('sonarqubeIns') {
                  sh './mvnw sonar:sonar'
                }
            }
        }

        stage("Quality Gate from SonarQube") {
            steps {
                timeout(time: 2, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage('Build Docker image') {
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
                         dockerImage.push("latest")
                         dockerImage.push()
                    }
                }
            }
        }
        stage('Trigger K8S Manifest Updating') {
            steps {
                build job: 'k8s-update-manifests-fleetman-api-gateway', parameters: [string(name: 'DOCKERTAG', value: commit_id)]
            }
        }
    }
}

