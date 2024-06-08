## Preparing Docker or reset state

Creating all needed docker networks.

```shell
 ./local/docker_networks_create.sh
```

Removing all containers (*updater* and *minio* optionally in the script).

```shell
  ./local/delete_containers.sh
```

## Creating MinIO and deploy it

Creating MinIO container and connect it to docker network. 
Also create bucket in the minio and access key.

Script for Linux:

```shell
 ./local/deploy_minio.sh
```

Script for Windows:

```shell
 ./local/deploy_minio_WIN.sh
```

## Creating images for components

Packaging components with Maven and build docker images on it.

```shell
 ./local/build_updater.sh
 ./local/build_balancer.sh
 ./local/build_pgfacade.sh
```

## Deploying docker containers

Deploying Updater and call it to deploy PgFacade, Balancer.
Then grant to superuser pgfacade user in postgres-node

```shell
  ./local/deploy_components.sh
```

if you'll get error about access denied during **docker run pgfacade-updater...** try to execute 
this command in your terminal