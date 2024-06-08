#!/bin/bash
# Checking for necessary PgFacade docker networks

postgresNetwork="pg-facade-postgres-network"
internalNetwork="pg-facade-internal-network"
externalNetwork="pg-facade-external-network"
balancerNetwork="pg-facade-balancer-network"
minioNetwork="pgfacade_minio-network"

echo "Checking docker network $postgresNetwork"
docker network inspect $postgresNetwork > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "Network $postgresNetwork has founded."
else
    docker network create $postgresNetwork
    echo "Network $postgresNetwork has created."
fi

echo "Checking docker network $internalNetwork"
docker network inspect $internalNetwork > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "Network $internalNetwork has founded."
else
    docker network create $internalNetwork
    echo "Network $internalNetwork has created."
fi

echo "Checking docker network $externalNetwork"
docker network inspect $externalNetwork > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "Network $externalNetwork has founded."
else
    docker network create $externalNetwork
    echo "Network $externalNetwork has created."
fi

echo "Checking docker network $balancerNetwork"
docker network inspect $balancerNetwork > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "Network $balancerNetwork has founded."
else
    docker network create $balancerNetwork
    echo "Network $balancerNetwork has created."
fi

echo "Checking docker network $minioNetwork"
docker network inspect $minioNetwork > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "Network $minioNetwork has founded."
else
    docker network create $minioNetwork
    echo "Network $minioNetwork has created."
fi