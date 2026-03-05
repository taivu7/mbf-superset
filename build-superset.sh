#!/bin/bash
set -e

SUPERSET_VERSION="6.0.0"
IMAGE_NAME="mbf/superset"
IMAGE_TAG="${SUPERSET_VERSION}"

echo "==> Cloning Apache Superset ${SUPERSET_VERSION}..."
if [ ! -d "superset-src" ]; then
    git clone --depth 1 --branch "${SUPERSET_VERSION}" https://github.com/apache/superset.git superset-src
else
    echo "    Source directory already exists, skipping clone."
fi

echo "==> Building Docker image ${IMAGE_NAME}:${IMAGE_TAG}..."
cd superset-src
docker build \
    --target lean \
    -t "${IMAGE_NAME}:${IMAGE_TAG}" \
    -t "${IMAGE_NAME}:latest" \
    .

echo "==> Build complete!"
echo "    Image: ${IMAGE_NAME}:${IMAGE_TAG}"
docker images "${IMAGE_NAME}"
