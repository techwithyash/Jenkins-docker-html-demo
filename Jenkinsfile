// Declarative Pipeline for Jenkins CI/CD
// This pipeline automates the build and deployment of our HTML application using Docker

pipeline {
    // Run on any available Jenkins agent
    agent any

    // Environment variables used throughout the pipeline
    environment {
        IMAGE_NAME     = "html-cicd"
        IMAGE_TAG      = "v${BUILD_NUMBER}"
        CONTAINER_NAME = "html-cicd-v${BUILD_NUMBER}"
    }

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
                echo "Building Docker image ${IMAGE_NAME}:${IMAGE_TAG}..."
                script {
                    // Build the Docker image and tag it using the versioned tag
                    // The '.' at the end means "use the current directory as build context"
                    bat "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
                }
            }
        }

        // STAGE 3: Stop any previously running containers for this app
        stage('Stop Existing Container') {
            steps {
                echo 'Stopping existing container(s) if running...'
                script {
                    // Because CONTAINER_NAME changes every build (it includes BUILD_NUMBER),
                    // we can't just stop "the same name" as last time. Instead we find any
                    // running container whose name starts with "html-cicd-v" and stop it.
                    // This avoids port 80 conflicts with a container from a previous build.
                    bat '''
                        for /f "tokens=*" %%i in ('docker ps -q --filter "name=html-cicd-v"') do docker stop %%i
                    '''
                }
            }
        }

        // STAGE 4: Remove old containers to free up the port/name
        stage('Remove Existing Container') {
            steps {
                echo 'Removing old container(s)...'
                script {
                    // Remove any (stopped) container whose name starts with "html-cicd-v"
                    bat '''
                        for /f "tokens=*" %%i in ('docker ps -aq --filter "name=html-cicd-v"') do docker rm %%i
                    '''
                }
            }
        }

        // STAGE 5: Start a new container with the freshly built image
        stage('Run New Container') {
            steps {
                echo "Starting new container ${CONTAINER_NAME}..."
                script {
                    // Run a new container with the following options:
                    // -d : Run in detached mode (background)
                    // --name : Give the container a unique, versioned name
                    // -p 80:80 : Map host port 80 to container port 80
                    // --restart unless-stopped : Automatically restart container if it crashes
                    //                            (but not if manually stopped)
                    bat "docker run -d --name ${CONTAINER_NAME} -p 80:80 --restart unless-stopped ${IMAGE_NAME}:${IMAGE_TAG}"
                }
            }
        }
    }

    // Post-build actions
    post {
        // Actions to run if the pipeline succeeds
        success {
            echo "Pipeline completed successfully!"
            echo "Image: ${IMAGE_NAME}:${IMAGE_TAG} | Container: ${CONTAINER_NAME}"
            echo "Your website is now live at http://localhost"
        }

        // Actions to run if the pipeline fails
        failure {
            echo 'Pipeline failed. Please check the logs above for errors.'
        }
    }
}