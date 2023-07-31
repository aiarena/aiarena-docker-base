# aiarena-docker
https://hub.docker.com/r/aiarena/arenaclient

## Archived

The AI Arena infrastructure now runs on [https://github.com/aiarena/sc2-ai-match-controller](https://github.com/aiarena/sc2-ai-match-controller)

## Local play

If you're just looking for a way to play local matches using docker, check out the [local-play-bootstrap](https://github.com/aiarena/local-play-bootstrap).

## Build

For general usage, we advise against building the image yourself - refer to the local-play-bootstrap above instead.  
Use the following command to build image with name `aiarena`:

```
docker build -t aiarena/arenaclient:latest --build-arg PYTHON_VERSION=3.9 --build-arg SC2_VERSION=4.10 --build-arg VERSION_NUMBER=1.0.0 .
```

## Tests

See ``test_docker_image.sh`` which builds both local dockerfiles and then runs the aiarena client with several bots and checks the results with expected outcomes.

## Usage

This docker can be used to run AI Arena ladder on a local machine.
Follow the steps below to configure and run an example match between two standard bots.

1. [Build](#Build) an image.
2. Copy file named `example_local_config.py` and rename its copy to `config.py`. If necessary, adjust
  any parameters inside.
3. Download the latest aiarena bots:

  ```
  git clone https://github.com/aiarena/aiarena-test-bots
  ```

  If you want to use other bots, you can download them as well.
4. Download [the latest maps](https://aiarena.net/wiki/maps/) for AI Arena ladder and unpack them
  into some empty directory.
5. Now create a file called `matches` with the following content:

  ```
  # Bot1 name, Bot1 race, Bot1 type, Bot2 name, Bot2 race, Bot2 type, Map
  basic_bot,T,python,loser_bot,T,python,DeathAuraLE
  ```

  You can add more matches if you want.
6. Run the docker container:

  ```
  export CONFIG_PATH="/path/to/your/config.py"
  export MATCHES_PATH="/path/to/your/matches"
  export BOTS_PATH="/path/to/your/bots"
  export MAPS_PATH="/path/to/your/maps"
  export REPLAYS_PATH="/path/to/new/empty/directory"
  docker run -v ${CONFIG_PATH}:/root/aiarena-client/config.py -v ${MATCHES_PATH}:/root/aiarena-client/matches -v ${BOTS_PATH}:/root/aiarena-client/bots -v ${MAPS_PATH}:/root/StarCraftII/maps ${REPLAYS_PATH}:/root/aiarena-client/replays:rw -v -it aiarena/arenaclient:latest
  ```

  After the command completes, replays will be available in `$REPLAYS_PATH` directory.
