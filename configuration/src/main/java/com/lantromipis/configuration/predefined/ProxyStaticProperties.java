package com.lantromipis.configuration.predefined;

import io.smallrye.config.ConfigMapping;

import java.util.Map;

@ConfigMapping(prefix = "pg-facade.proxy")
public interface ProxyStaticProperties {
    int port();

    Map<String, String> parameterStatusOverride();
}