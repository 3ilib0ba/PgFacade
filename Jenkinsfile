@Library('COSM-Jenkins-libs') _

pipeline {

    agent none

    options {
        // This is required if you want to clean before build
        skipDefaultCheckout(true)
    }

    stages {

        stage('Preparation') {
            agent { node { label 'master' } }
            steps {
                step([$class: 'WsCleanup'])

                checkout scm

                sh '''#!/bin/bash
                    git log -n 1 | grep "commit " | sed 's/commit //g' > currenntVersion
                '''

                stash name:'workspace', includes:'**'
            }
        }

        stage('Build application') {
            agent { docker {
                    image 'maven:3.8.8-eclipse-temurin-21-alpine'
                    // Run the container on the node specified at the
                    // top-level of the Pipeline, in the same workspace,
                    // rather than on a new node entirely:
                    reuseNode true
                    args '-u root'
                } }
            steps {
                unstash 'workspace'
                sh '''#!/bin/bash
                    echo "----------------------"
                    pwd
                    echo "----------------------"
                    ls -la
                    echo "----------------------"
                    mvn -B clean install

                    echo "---------------------- BUILD STARTED ----------------------"
                    # 1. Call steps of building artifacts:
                    apt-get update
                    apt-get install -y docker-ce-cli
                    chmod -R +x ./.infrastructure
                    cd ./.infrastructure

                    ./build_updater.sh
                    ./build_balancer.sh
                    ./build_pgfacade.sh

                    cd ..
                    echo "--------------------- BUILD  FINISHED ---------------------"
                '''
            }
        }

        stage('Deploy artifacts') {
            agent {
                docker {
                    image 'docker-builder'
                    // Run the container on the node specified at the
                    // top-level of the Pipeline, in the same workspace,
                    // rather than on a new node entirely:
                    reuseNode true
                    args '-u root --net="main_bridge" -v /var/run/docker.sock:/var/run/docker.sock'
                }
            }
            steps {
                sh '''#!/bin/bash
                    # 2. Deploying images to containers with MinIO:
                    echo "---------------------- DEPLOY TO LAB STARTED ----------------------"
                    chmod -R +x ./.infrastructure
                    cd ./.infrastructure/lab

                    ./docker_networks_create.sh
                    ./deploy_minio_lab.sh
                    ./deploy_components_lab.sh

                    echo "---------------------- DEPLOY TO LAB FINISHED ----------------------"

                    # 3. Call all tests (with report)
                    echo "---------------------- TEST PGFACADE STARTED ----------------------"
                    echo "Waiting for full application started in the Docker (sleep 1 minute)"
                    sleep 60

                    ./get_all_pg_facade_containers.sh

                    echo "---------------------- TEST PGFACADE FINISHED ----------------------"

                    # 4. Stopping and removing all PgFacade containers
                    echo "---------------------- DELETING PGFACADE STARTED ----------------------"
                    echo "Stopping and removing all containers. "

                    ./delete_all_pg_containers.sh

                    echo "PgFacade containers remained (should be empty): "
                    ./get_all_pg_facade_containers.sh

                    echo "---------------------- DELETING PGFACADE FINISHED ----------------------"

                    # 5. Deploying new version of app if it's needed
                '''
            }
        }
    }

    post {
        always {
            node ('master') {
                script {
                    env.GIT_URL = env.GIT_URL_1
                    notifyRocketChat(
                        channelName: 'system_notifications_pgfacade',
                        minioCredentialsId: 'jenkins-minio-credentials',
                        minioHostUrl: 'https://minio.cloud.cosm-lab.science'
                    )
                }
            }
        }
    }
}