package com.lantromipis.util;

import com.github.dockerjava.api.command.InspectContainerResponse;
import com.github.dockerjava.api.model.Container;
import com.github.dockerjava.api.model.ContainerNetwork;
import com.github.dockerjava.api.model.ContainerNetworkSettings;
import com.lantromipis.properties.statics.OrchestrationProperties;

import javax.enterprise.context.ApplicationScoped;
import javax.inject.Inject;
import java.util.Optional;

@ApplicationScoped
public class DockerUtils {

    @Inject
    OrchestrationProperties orchestrationProperties;

    public String getContainerIpAddress(InspectContainerResponse inspectContainerResponse) {
        ContainerNetwork containerNetwork = inspectContainerResponse.getNetworkSettings().getNetworks().get(orchestrationProperties.docker().postgresNetworkName());
        if (containerNetwork == null) {
            return null;
        }

        return containerNetwork.getIpAddress();
    }

    public String getContainerIpAddress(Container container) {
        return Optional.of(container)
                .map(Container::getNetworkSettings)
                .map(ContainerNetworkSettings::getNetworks)
                .map(map -> map.get(orchestrationProperties.docker().postgresNetworkName()))
                .map(ContainerNetwork::getIpAddress)
                .orElse(null);
    }
}
