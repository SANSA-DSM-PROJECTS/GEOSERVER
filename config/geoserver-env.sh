#!/bin/bash

# ── MinIO / S3 ─────────────────────────────────────────────
export AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID}"
export AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY}"
export AWS_REGION="${AWS_REGION:-us-east-1}"
export AWS_S3_ENDPOINT="${AWS_S3_ENDPOINT}"
export AWS_ENDPOINT_URL="${AWS_ENDPOINT_URL}"
export AWS_S3_ADDRESSING_STYLE="${AWS_S3_ADDRESSING_STYLE:-path}"
export AWS_HTTPS="${AWS_HTTPS:-NO}"
export AWS_VIRTUAL_HOSTING="${AWS_VIRTUAL_HOSTING:-FALSE}"

# ── GeoServer S3 Plugin ────────────────────────────────────
export S3_ENDPOINT="${S3_ENDPOINT}"
export S3_ALIAS="${S3_ALIAS}"
export S3_USER="${S3_USER}"
export S3_PASS="${S3_PASS}"

# ── imageio-ext S3 Range Reader ────────────────────────────
export IIO_S3_AWS_USER="${IIO_S3_AWS_USER:-$AWS_ACCESS_KEY_ID}"
export IIO_S3_AWS_PASSWORD="${IIO_S3_AWS_PASSWORD:-$AWS_SECRET_ACCESS_KEY}"
export IIO_S3_AWS_REGION="${IIO_S3_AWS_REGION:-$AWS_REGION}"
export IIO_S3_AWS_ENDPOINT="${IIO_S3_AWS_ENDPOINT}"
export IIO_S3_AWS_CORE_POOL_SIZE="${IIO_S3_AWS_CORE_POOL_SIZE:-100}"
export IIO_S3_AWS_MAX_POOL_SIZE="${IIO_S3_AWS_MAX_POOL_SIZE:-256}"
export IIO_S3_AWS_KEEP_ALIVE_TIME="${IIO_S3_AWS_KEEP_ALIVE_TIME:-30}"

# ── EXTRA_JAVA_OPTS with all -D flags ──────────────────────
export EXTRA_JAVA_OPTS="-Xms1G -Xmx2G \
  -Dit.geosolutions.cog.default.header.length=65536 \
  -DIIO_S3_AWS_USER=${IIO_S3_AWS_USER} \
  -DIIO_S3_AWS_PASSWORD=${IIO_S3_AWS_PASSWORD} \
  -DIIO_S3_AWS_REGION=${IIO_S3_AWS_REGION} \
  -DIIO_S3_AWS_ENDPOINT=${IIO_S3_AWS_ENDPOINT} \
  -DIIO_S3_AWS_CORE_POOL_SIZE=${IIO_S3_AWS_CORE_POOL_SIZE} \
  -DIIO_S3_AWS_MAX_POOL_SIZE=${IIO_S3_AWS_MAX_POOL_SIZE} \
  -DIIO_S3_AWS_KEEP_ALIVE_TIME=${IIO_S3_AWS_KEEP_ALIVE_TIME} \
  -Daws.accessKeyId=${AWS_ACCESS_KEY_ID} \
  -Daws.secretAccessKey=${AWS_SECRET_ACCESS_KEY} \
  -Daws.region=${AWS_REGION} \
  -Daws.endpointUrl=${AWS_S3_ENDPOINT} \
  -javaagent:/opt/additional_libs/jmx_prometheus_javaagent-0.20.0.jar=9091:/opt/config/jmx-config.yml"


echo "✅ GeoServer environment variables loaded"
echo "   S3_ENDPOINT: $S3_ENDPOINT"
echo "   IIO_S3_AWS_ENDPOINT: $IIO_S3_AWS_ENDPOINT"
echo "   EXTRA_JAVA_OPTS: $EXTRA_JAVA_OPTS"