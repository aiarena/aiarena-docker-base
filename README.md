# aiarena-docker-base

A collection of base images used by the [AI Arena Match Controller](https://github.com/aiarena/sc2-ai-match-controller).

## [arenaclient-sc2-base](https://hub.docker.com/r/aiarena/arenaclient-sc2-base)

**Dockerfile: [docker/Dockerfile.sc2](docker/Dockerfile.sc2)**  
This image contains the SC2 game pre-installed.

## [arenaclient-bot-base](https://hub.docker.com/r/aiarena/arenaclient-bot-base)

**Dockerfile: [docker/Dockerfile.bot](docker/Dockerfile.bot)**  
This image contains all the different technologies and dependencies for agents to run in the AI Arena.

### Bumping the Python version

To bump the python version: 
1. Set the `PYTHON_VERSION` environment variable in the [Dockerfile](docker/Dockerfile.bot) to the desired version. This will ensure it is installed in the image.
2. Update the `python` version range entry in the [pyproject.toml](pyproject.toml). This will ensure compatible dependencies are installed.

### Bumping Python dependencies

The [pyproject.toml](pyproject.toml) file describes required dependencies for the bot image.  
To bump the dependencies, first set any specifically desired versions (or leave them as "*") in the `pyproject.toml` file.  
Then run the following command:
```
docker compose -f docker/docker-compose.yml run --rm poetry-update
```
This will build the bot image and then run `poetry update` which will update the `poetry.lock` file with the latest versions.
It will also generate a report in the output of the command showing the changes made.