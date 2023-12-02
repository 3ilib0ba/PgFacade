package com.lantromipis.rest.exceptionmapper;

import com.lantromipis.rest.exception.GeneralRequestProcessingException;
import com.lantromipis.rest.model.api.error.ErrorDto;
import jakarta.ws.rs.core.Response;
import jakarta.ws.rs.ext.ExceptionMapper;
import jakarta.ws.rs.ext.Provider;
import lombok.extern.slf4j.Slf4j;

import java.time.Instant;

@Slf4j
@Provider
public class GeneralRequestProcessingExceptionMapper implements ExceptionMapper<GeneralRequestProcessingException> {
    @Override
    public Response toResponse(GeneralRequestProcessingException exception) {
        log.error("Error processing REST request. ", exception);
        return Response
                .serverError()
                .entity(
                        ErrorDto
                                .builder()
                                .status(Response.Status.INTERNAL_SERVER_ERROR.getStatusCode())
                                .timestamp(Instant.now())
                                .message("Something went wrong. Try again. Cause: " + exception.getMessage())
                                .build()
                )
                .build();
    }
}
