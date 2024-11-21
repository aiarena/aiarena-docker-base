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
3. Follow the steps below to bump the dependencies and generate a report as they might change based upon the new python version.

### Bumping Python dependencies and generating a report

The [pyproject.toml](pyproject.toml) file describes required dependencies for the bot image.  
To bump the dependencies, first set any specifically desired versions (or leave them as "*") in the `pyproject.toml` file.  
Then run the following command:
```
# Report the previous requirements.txt file
PREVIOUS_VERSION=v0.0.0  # the previous version arenaclient-bot-base image that we're comparing to
# Take the requirements output from the console of the following command and save it to before.requirements.txt
docker run -it aiarena/arenaclient-bot-base:${PREVIOUS_VERSION} bash -c "pip install poetry && poetry export -f requirements.txt --without-hashes"

# This will build the bot image and then run `poetry update` which will update the `poetry.lock` file with the latest versions.
# After running this, copy the requirements.txt content output from the console and save it to after.requirements.txt
# Note: if you don't get the requirements.txt content output, it likely means something failed.
docker compose -f docker/docker-compose.yml run --rm --build poetry-update

# This will generate a report showing the changes made.
python ./requirements_diff.py
```