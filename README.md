# aiarena-docker-base

A collection of base images used by the [AI Arena Match Controller](https://github.com/aiarena/sc2-ai-match-controller).

## [arenaclient-sc2-base](https://hub.docker.com/r/aiarena/arenaclient-sc2-base)

**Dockerfile: [docker/Dockerfile.sc2](docker/Dockerfile.sc2)**  
This image contains the SC2 game pre-installed.

## [arenaclient-bot-base](https://hub.docker.com/r/aiarena/arenaclient-bot-base)

**Dockerfile: [docker/Dockerfile.bot](docker/Dockerfile.bot)**  
This image contains all the different technologies and dependencies for agents to run in the AI Arena.  
The [poetry.lock](poetry.lock) file describes the dependencies for Python agents that are installed in the image.