#!/bin/bash

# Deploying MinIO container
PgFacadeMinioContainerId=$(docker run \
                                      -e MINIO_ROOT_USER=s3user \
                                      -e MINIO_ROOT_PASSWORD=s3password \
                                      --name pgfacade-minio-test \
                                      --net-alias minio \
                                      -d minio/minio:latest server \
                                      --console-address ":9001" /data)
echo "MinIO container ID: $PgFacadeMinioContainerId"

# Some commands about configure have to call in container
execute_in_container() {
    docker exec -i "$PgFacadeMinioContainerId" bash -c "$1"
}

# Downloaded mc (minio client) for configuring minio
execute_in_container "curl -sSLo /usr/local/bin/mc https://dl.min.io/client/mc/release/linux-amd64/mc && chmod +x /usr/local/bin/mc"
# Configuring access to MinIO
execute_in_container "/usr/local/bin/mc alias set minio http://localhost:9000 s3user s3password"
# Creating bucket pgfacade
execute_in_container "/usr/local/bin/mc mb minio/pgfacade"
# Creating access key
execute_in_container "/usr/local/bin/mc admin user svcacct add minio s3user --access-key 'Rre6lc6yiubAgi9H' --secret-key 'EEmKeAC4ocIX2qOp2cvxNO3bnOsRN121'"


# Checking for docker network pgfacade_minio-network
echo "Checking docker network pgfacade_minio-network"
docker network inspect pgfacade_minio-network > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "Network pgfacade_minio-network has founded. Connecting with minio..."
else
    docker network create pgfacade_minio-network
    echo "Network pgfacade_minio-network has created. Connection with minio..."
fi

# Connection minio to docker network
docker network connect --alias minio pgfacade_minio-network $PgFacadeMinioContainerId
echo "minio container connected to docker network pgfacade_minio-network. Alias of container -> minio."

