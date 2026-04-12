#!/bin/bash
echo "🔧 setenv.sh: Injecting S3 and JVM configuration..."

# ── Validate required variables are present ───────────────
REQUIRED_VARS=(
  "S3_ENDPOINT"
  "S3_ALIAS"
  "S3_USER"
  "S3_PASS"
  "AWS_ACCESS_KEY_ID"
  "AWS_SECRET_ACCESS_KEY"
  "AWS_REGION"
  "IIO_S3_AWS_ENDPOINT"
)

for VAR in "${REQUIRED_VARS[@]}"; do
  if [ -z "${!VAR}" ]; then
    echo "❌ ERROR: Required environment variable $VAR is not set!"
    echo "   Check your .env file and docker-compose.yml"
    exit 1
  fi
done

# ── GeoServer S3 Plugin ────────────────────────────────────
export S3_ENDPOINT="${S3_ENDPOINT}"
export S3_ALIAS="${S3_ALIAS}"
export S3_USER="${S3_USER}"
export S3_PASS="${S3_PASS}"

# ── AWS SDK ────────────────────────────────────────────────
export AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID}"
export AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY}"
export AWS_REGION="${AWS_REGION:-us-east-1}"
export AWS_S3_ENDPOINT="${AWS_S3_ENDPOINT}"
export AWS_ENDPOINT_URL="${AWS_ENDPOINT_URL}"
export AWS_S3_ADDRESSING_STYLE="${AWS_S3_ADDRESSING_STYLE:-path}"
export AWS_HTTPS="${AWS_HTTPS:-NO}"
export AWS_VIRTUAL_HOSTING="${AWS_VIRTUAL_HOSTING:-FALSE}"

# ── imageio-ext S3 Range Reader ────────────────────────────
export IIO_S3_AWS_USER="${IIO_S3_AWS_USER:-$AWS_ACCESS_KEY_ID}"
export IIO_S3_AWS_PASSWORD="${IIO_S3_AWS_PASSWORD:-$AWS_SECRET_ACCESS_KEY}"
export IIO_S3_AWS_REGION="${IIO_S3_AWS_REGION:-$AWS_REGION}"
export IIO_S3_AWS_ENDPOINT="${IIO_S3_AWS_ENDPOINT}"
export IIO_S3_AWS_CORE_POOL_SIZE="${IIO_S3_AWS_CORE_POOL_SIZE:-100}"
export IIO_S3_AWS_MAX_POOL_SIZE="${IIO_S3_AWS_MAX_POOL_SIZE:-256}"
export IIO_S3_AWS_KEEP_ALIVE_TIME="${IIO_S3_AWS_KEEP_ALIVE_TIME:-30}"

export CATALINA_OPTS="${EXTRA_JAVA_OPTS:-"-Xms1G -Xmx2G"} \
  --add-exports=java.desktop/com.sun.imageio.plugins.jpeg=ALL-UNNAMED \
  --add-exports=java.desktop/com.sun.imageio.plugins.png=ALL-UNNAMED \
  --add-exports=java.desktop/sun.awt.image=ALL-UNNAMED \
  --add-opens=java.base/java.lang=ALL-UNNAMED \
  --add-opens=java.base/java.util=ALL-UNNAMED \
  --add-opens=java.base/java.lang.reflect=ALL-UNNAMED \
  --add-opens=java.base/java.text=ALL-UNNAMED \
  --add-opens=java.desktop/java.awt.font=ALL-UNNAMED \
  --add-opens=java.desktop/java.awt.image=ALL-UNNAMED \
  --add-opens=java.desktop/javax.imageio.stream=ALL-UNNAMED \
  --add-opens=java.desktop/javax.imageio=ALL-UNNAMED \
  --add-opens=java.desktop/sun.awt.image=ALL-UNNAMED \
  --add-opens=java.naming/com.sun.jndi.ldap=ALL-UNNAMED \
  --add-opens=java.desktop/sun.java2d.pipe=ALL-UNNAMED \
  -Djava.awt.headless=true \
  -server \
  -Dfile.encoding=UTF-8 \
  -Djavax.servlet.request.encoding=UTF-8 \
  -Djavax.servlet.response.encoding=UTF-8 \
  -XX:SoftRefLRUPolicyMSPerMB=36000 \
  -Xbootclasspath/a:/usr/local/tomcat/lib/marlin.jar \
  -Dsun.java2d.renderer=sun.java2d.marlin.DMarlinRenderingEngine \
  -Dorg.geotools.coverage.jaiext.enabled=true \
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

echo "✅ setenv.sh complete"
echo "   S3_ENDPOINT         : ${S3_ENDPOINT}"
echo "   IIO_S3_AWS_ENDPOINT : ${IIO_S3_AWS_ENDPOINT}"
echo "   AWS_REGION          : ${AWS_REGION}"
echo "   JMX Port            : 9091"