// Declarative Pipeline for Jenkins CI/CD
// This pipeline automates the build and deployment of our HTML application using Docker

pipeline {
    // Run on any available Jenkins agent
    agent any
    
    stages {
        // STAGE 1: Checkout the latest source code from GitHub
        stage('Checkout') {
            steps {
                // Jenkins automatically checks out the repository
                // that triggered this build (configured in Jenkins job settings)
                echo 'Checking out source code from GitHub...'
                checkout scm
            }
        }
        
        // STAGE 2: Build a new Docker image from the Dockerfile
        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image...'
                script {
                    // Build the Docker image and tag it as 'hello-html-app:latest'
                    // The '.' at the end means "use the current directory as build context"
                    bat 'docker build -t hello-html-app:latest .'
                }
            }
        }
        
        // STAGE 3: Stop the existing running container (if any)
        stage('Stop Existing Container') {
            steps {
                echo 'Stopping existing container if running...'
                script {
                    // Stop the container named 'hello-html-container'
                    // The '|| exit 0' ensures the pipeline doesn't fail if container doesn't exist
                    bat 'docker stop hello-html-container || exit 0'
                }
            }
        }
        
        // STAGE 4: Remove the old container to free up the name
        stage('Remove Existing Container') {
            steps {
                echo 'Removing old container...'
                script {
                    // Remove the container named 'hello-html-container'
                    // The '|| exit 0' ensures the pipeline doesn't fail if container doesn't exist
                    bat 'docker rm hello-html-container || exit 0'
                }
            }
        }
        
        // STAGE 5: Start a new container with the freshly built image
        stage('Run New Container') {
            steps {
                echo 'Starting new container...'
                script {
                    // Run a new container with the following options:
                    // -d : Run in detached mode (background)
                    // --name : Give the container a specific name for easy management
                    // -p 80:80 : Map host port 80 to container port 80
                    // --restart unless-stopped : Automatically restart container if it crashes
                    //                            (but not if manually stopped)
                    bat 'docker run -d --name hello-html-container -p 80:80 --restart unless-stopped hello-html-app:latest'
                }
            }
        }
    }
    
    // Post-build actions
    post {
        // Actions to run if the pipeline succeeds
        success {
            echo ' Pipeline completed successfully!'
            echo ' Your website is now live at http://localhost'
        }
        
        // Actions to run if the pipeline fails
        failure {
            echo 'Pipeline failed. Please check the logs above for errors.'
        }
    }
}
