#!/bin/bash

needToDeleteUpdater=true
needToDeleteMinio=true

# Searching containers and removing it
stop_and_remove_containers_by_name() {
    # Getting all ids of containers by name pattern
    container_ids_array=( $(docker ps -a --filter "name=$1" --format "{{.ID}}") )

    # Checking for having containers for deleting
    if [ -n "$container_ids_array" ]; then
        # Output all containers (id -> fullname)
        echo "Founded next ids of containers for removing: "
        for container_id in "${container_ids_array[@]}"; do
            local container_name=$(docker inspect --format='{{.Name}}' "$container_id" | sed 's/^\/\|$//g')
            echo "$container_id -> $container_name"
        done

        # Stopping and then removing each container
        for container_id in "${container_ids_array[@]}"; do
            {
                echo "Stopping container ID: $container_id"
                docker stop "$container_id"
                echo "Removing container ID: $container_id"
                docker rm "$container_id"
            } &
        done
        wait
    else
        echo "No container IDs in result_array for command docker filter..."
    fi

}

echo "-------------------- DELETE CONTAINERS STARTED --------------------"

printf "Start deleting pg-facade-nodes\n"
stop_and_remove_containers_by_name "pg-facade-node"

printf "\nStart deleting PgFacade temp nodes\n"
stop_and_remove_containers_by_name "pg-facade-temp"

printf "\nStart deleting load-balancer container\n"
stop_and_remove_containers_by_name "pg-facade-load-balancer"

printf "\nStart deleting postgres nodes\n"
stop_and_remove_containers_by_name "pg-facade-managed-postgres"

printf "\nAnother checking for PgFacade auto-created containers via RAFT (pg-facade-node... and pg-facade-temp..."
printf "\nStart deleting pg-facade-nodes\n"
stop_and_remove_containers_by_name "pg-facade-node"

printf "\nStart deleting PgFacade temp nodes\n"
stop_and_remove_containers_by_name "pg-facade-temp"

# Удаление pgfacade-updater, если переменная needToDeleteUpdater равна true
if [ "$needToDeleteUpdater" = true ]; then
    printf "\nStart deleting pgfacade-updater\n"
    stop_and_remove_containers_by_name "pgfacade-updater"
fi

# Удаление pgfacade-minio-test, если переменная needToDeleteMinio равна true
if [ "$needToDeleteMinio" = true ]; then
    printf "\nStart deleting pgfacade-minio-test\n"
    stop_and_remove_containers_by_name "pgfacade-minio-test"
fi

echo "-------------------- DELETE CONTAINERS FINISHED -------------------"