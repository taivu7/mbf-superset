FROM python:3.11-slim-bookworm

ARG SUPERSET_VERSION=6.0.0

ENV SUPERSET_HOME="/app/superset_home" \
    PYTHONPATH="/app/pythonpath" \
    FLASK_APP="superset.app:create_app()" \
    SUPERSET_PORT=8088

# Create superset user
RUN useradd --create-home --shell /bin/bash superset && \
    mkdir -p ${SUPERSET_HOME} ${PYTHONPATH} && \
    chown -R superset:superset ${SUPERSET_HOME} ${PYTHONPATH}

# Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        curl \
        libsasl2-dev \
        libsasl2-modules-gssapi-mit \
        libpq-dev \
        libecpg-dev \
        libldap2-dev \
        pkg-config \
        default-libmysqlclient-dev && \
    rm -rf /var/lib/apt/lists/*

# Install Superset and database drivers
RUN pip install --no-cache-dir \
    apache-superset==${SUPERSET_VERSION} \
    psycopg2-binary \
    redis \
    pillow \
    oracledb

WORKDIR /app
EXPOSE ${SUPERSET_PORT}

USER superset

HEALTHCHECK --interval=30s --timeout=10s --retries=5 \
    CMD curl -f http://localhost:${SUPERSET_PORT}/health || exit 1

CMD ["gunicorn", "--bind", "0.0.0.0:8088", "--workers", "4", "--worker-class", "gthread", "--threads", "20", "--timeout", "120", "--limit-request-line", "0", "--limit-request-field_size", "0", "superset.app:create_app()"]
