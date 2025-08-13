# Minimal Java runtime for the CLI validator
FROM eclipse-temurin:21-jre-alpine

# Pin (optional): change to a specific version, e.g. 6.6.3
ARG VALIDATOR_URL="https://github.com/hapifhir/org.hl7.fhir.core/releases/latest/download/validator_cli.jar"

ENV JAVA_OPTS="-Xms256m -Xmx2g"
ENV FHIR_CACHE=/work/.fhir/packages
WORKDIR /work

RUN apk add --no-cache curl ca-certificates && update-ca-certificates && \
    mkdir -p "${FHIR_CACHE}" && \
    curl -fL -o /work/validator_cli.jar "${VALIDATOR_URL}" && \
    printf '#!/bin/sh\nexec java $JAVA_OPTS -jar /work/validator_cli.jar "$@"\n' > /usr/local/bin/validator && \
    chmod +x /usr/local/bin/validator

ENTRYPOINT ["validator"]
