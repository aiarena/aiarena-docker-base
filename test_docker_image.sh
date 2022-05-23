# This script is meant for development, which produces fresh images and then runs tests

# Set which versions to use
export PYTHON_VERSION=3.9
export SC2_VERSION=4.10
export VERSION_NUMBER=1.0.0

# Build images
docker build -f sc2linuxbase-docker/Dockerfile -t aiarena/sc2-linux-base:py_$PYTHON_VERSION-sc2_$SC2_VERSION-v$VERSION_NUMBER --build-arg PYTHON_VERSION=$PYTHON_VERSION --build-arg SC2_VERSION=$SC2_VERSION .
docker build -t aiarena/arenaclient:latest --build-arg PYTHON_VERSION=$PYTHON_VERSION --build-arg SC2_VERSION=$SC2_VERSION --build-arg VERSION_NUMBER=$VERSION_NUMBER .

# Delete previous container if it exists
docker rm -f testcontainer

# Start container with correct env variables, override the default entrypoint
docker run -it -d \
  --name testcontainer \
  --env SC2_PROXY_BIN=SC2_x64 \
  --env SC2_PROXY_BASE=/root/StarCraftII/ \
  --entrypoint /bin/bash \
  --workdir="/root/aiarena-client" \
  aiarena/arenaclient:latest

# Add maps
docker exec -it testcontainer bash -c "cp -R /root/aiarena-client/testing/maps/* /root/StarCraftII/maps"
# Add bots
docker exec -it testcontainer bash -c "git clone https://github.com/aiarena/aiarena-test-bots testing/aiarena-test-bots"

# Run integration tests, this may take around 15 minutes
docker exec -it testcontainer bash -c "python -m arenaclient --test"

# Command for entering the container to debug if something went wrong:
# docker exec -it testcontainer bash
