# This script is meant for development, which produces fresh images and then runs tests

# Build images
docker build -t aiarena/sc2-linux-base:py_3.9-sc2_4.10-v1.0.0 --build-arg PYTHON_VERSION=3.9 --build-arg SC2_VERSION=4.10 sc2linuxbase-docker
docker build -t aiarena/arenaclient:latest --build-arg PYTHON_VERSION=3.9 --build-arg SC2_VERSION=4.10 --build-arg VERSION_NUMBER=1.0.0 .

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
docker exec -it testcontainer bash -c "cp -R /root/aiarena-client/testing/maps /root/StarCraftII/maps"
# Add bots
docker exec -it testcontainer bash -c "git clone https://github.com/aiarena/aiarena-test-bots testing/aiarena-test-bots"

# Run integration tests, this may take around 15 minutes
docker exec -it testcontainer bash -c "python -m arenaclient --test"

# Command for entering the container to debug if something went wrong:
# docker exec -it testcontainer bash
