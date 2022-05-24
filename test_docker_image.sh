# This script is meant for development, which produces fresh images and then runs tests

# Set which versions to use
export VERSION_NUMBER=${VERSION_NUMBER:-1.0.0}
export PYTHON_VERSION=${PYTHON_VERSION:-3.9}
export SC2_VERSION=${SC2_VERSION:-4.10}

# Allow image squashing by enabling experimental docker features
# https://stackoverflow.com/a/21164441/10882657
# https://github.com/actions/virtual-environments/issues/368#issuecomment-582387669
file=/etc/docker/daemon.json
if [ ! -e "$file" ]; then
  echo $'{\n    "experimental": true\n}' | sudo tee /etc/docker/daemon.json
  sudo systemctl restart docker.service
fi

# SC2LINUXBASE
# Build images
docker build -t aiarena/sc2-linux-base:py_$PYTHON_VERSION-sc2_$SC2_VERSION-v$VERSION_NUMBER --build-arg PYTHON_VERSION=$PYTHON_VERSION --build-arg SC2_VERSION=$SC2_VERSION - < sc2linuxbase-docker/Dockerfile
# Squash image
#docker build -t aiarena/sc2-linux-base:py_$PYTHON_VERSION-sc2_$SC2_VERSION-v$VERSION_NUMBER-squashed --squash --build-arg PYTHON_VERSION=$PYTHON_VERSION --build-arg SC2_VERSION=$SC2_VERSION - < sc2linuxbase-docker/Dockerfile

# ARENACLIENT
docker build -t aiarena/arenaclient:local --build-arg PYTHON_VERSION=$PYTHON_VERSION --build-arg SC2_VERSION=$SC2_VERSION --build-arg VERSION_NUMBER=$VERSION_NUMBER .
# Squash image
#docker build -t aiarena/arenaclient:local-squashed --squash --build-arg PYTHON_VERSION=$PYTHON_VERSION --build-arg SC2_VERSION=$SC2_VERSION --build-arg VERSION_NUMBER=$VERSION_NUMBER .

# Build arenaclient from squashed base image
#docker build -t aiarena/arenaclient:local --build-arg PYTHON_VERSION=$PYTHON_VERSION --build-arg SC2_VERSION=$SC2_VERSION --build-arg VERSION_NUMBER=$VERSION_NUMBER --build-arg USE_SQUASHED="-squashed" .
# Squash image
#docker build -t aiarena/arenaclient:local-squashed --squash --build-arg PYTHON_VERSION=$PYTHON_VERSION --build-arg SC2_VERSION=$SC2_VERSION --build-arg VERSION_NUMBER=$VERSION_NUMBER --build-arg USE_SQUASHED="-squashed" .

# Delete previous container if it exists
docker rm -f testcontainer

# Start container with correct env variables, override the default entrypoint
docker run -i -d \
  --name testcontainer \
  --env SC2_PROXY_BIN=SC2_x64 \
  --env SC2_PROXY_BASE=/root/StarCraftII/ \
  --entrypoint /bin/bash \
  --workdir="/root/aiarena-client" \
  aiarena/arenaclient:local

# Add maps
docker exec -i testcontainer bash -c "cp -R /root/aiarena-client/testing/maps/* /root/StarCraftII/maps"
# Add bots
docker exec -i testcontainer bash -c "git clone https://github.com/aiarena/aiarena-test-bots testing/aiarena-test-bots"

# Run integration tests, this may take around 15 minutes
docker exec -i testcontainer bash -c "python -m arenaclient --test"

# Command for entering the container to debug if something went wrong:
# docker exec -it testcontainer bash
