#!/bin/bash

PgFacadeContainers=()

# Function for adding another PgFacade containers by name
add_containers_by_name() {
    local container_name="$1"
    local container_ids=($(docker ps -a --filter "name=$container_name" --format "{{.ID}}"))
    PgFacadeContainers+=("${container_ids[@]}")
}

# Output all containers linked with PgFacade
output_all_pg_facade_containers() {
    # Output all containers (id -> fullname)
    echo "Founded next PgFacade containers (updater, minio, nodes, postgres, balancer, temps): "
    for container_id in "${PgFacadeContainers[@]}"; do
        local container_name=$(docker inspect --format='{{.Name}}' "$container_id" | sed 's/^\/\|$//g')
        echo "$container_id -> $container_name"
    done
}

# Searching containers of PgFacade
add_containers_by_name "pgfacade-updater"
add_containers_by_name "pgfacade-minio-test"
add_containers_by_name "pg-facade-node"
add_containers_by_name "pg-facade-load-balancer"
add_containers_by_name "pg-facade-managed-postgres"
add_containers_by_name "pg-facade-temp"

output_all_pg_facade_containers
