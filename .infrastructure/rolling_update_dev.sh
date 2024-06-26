#!/bin/bash

# Переменные для запроса
leaderContainerId="2821fe1a1fa44a4c7ffb45e250909e9bc88263230de68495e8b42a756ac1b140"
loadBalancerContainerId="1bc7c6f650de3d14398fc0e2e5a483c847d658c31a3f1728de1be3c634ee9e0f"
loadBalancerRefreshIntervalSeconds=5
pgFacadeHttpPort=8080
newPgFacadeImageTag="pgfacade-pgfacade:latest"
oldNodesAwaitClientsSeconds=3600

curl -L 'http://localhost:9090/docker/rolling-update' \
-H 'Content-Type: application/json' \
-d '{
    "leaderContainerId": '"${leaderContainerId}"',
    "loadBalancerContainerId": '"${loadBalancerContainerId}"',
    "loadBalancerRefreshIntervalSeconds": '"${loadBalancerRefreshIntervalSeconds}"',
    "pgFacadeInternalNetworkName": "pg-facade-internal-network",
    "pgFacadeExternalNetworkName": "pg-facade-external-network",
    "pgFacadeHttpPort": '"${pgFacadeHttpPort}"',
    "newPgFacadeImageTag": '"${newPgFacadeImageTag}"',
    "oldNodesAwaitClientsSeconds": '"${oldNodesAwaitClientsSeconds}"',
    "newPgFacadeEnvVars": {
        "PG_FACADE_ORCHESTRATION_COMMON_EXTERNAL_LOAD_BALANCER_DEPLOY": "true",
        "PG_FACADE_ARCHIVING_S3_BACKUPS_BUCKET": "pgfacade",
        "PG_FACADE_ARCHIVING_S3_WAL_BUCKET": "pgfacade",
        "PG_FACADE_ARCHIVING_S3_ENDPOINT": "http://minio:9000"
    },
    "mountDockerSock": true,
    "dockerSockPathOnHost": "/var/run/docker.sock",
    "networkNamesToConnect": [
        "pg-facade-postgres-network",
        "pg-facade-internal-network",
        "pg-facade-external-network",
        "pg-facade-balancer-network",
        "pgfacade_minio-network"
    ]
}'
