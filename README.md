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
docker run -it aiarena/arenaclient-bot-base:${PREVIOUS_VERSION} bash -c "pip install uv && uv export --format requirements.txt --no-hashes --no-header --no-annotate --no-cache -o requirements.txt"

# This will build the bot image and then run `uv sync` which will update the `uv.lock` file with the latest versions.
# After running this, copy the requirements.txt content output from the console and save it to after.requirements.txt
# Note: if you don't get the requirements.txt content output, it likely means something failed.
docker compose -f docker/docker-compose.yml run --rm --build uv-update

# This will generate a report showing the changes made.
python ./requirements_diff.py
```

### Performing a release

First determine your release version.
Prefix the release version with the image you want to release:
- For the bot image release version, use "bot-" (e.g. bot-v0.8.0)
- For the SC2 base image release version, use "sc2-" (e.g. sc2-v0.8.0)

To perform a release of a new version of the bot image, follow these steps:
1. In this GitHub repository, click on the "Releases" heading on the right side, then "Draft a new release".
2. Click to select a tag, enter the version tag you want to create (e.g. bot-v0.8.0) and click "Create new tag" and confirm.
3. Enter a title for the release (e.g. "Release bot-v0.8").
4. Click "Generate release notes" to auto-generate the release notes, then edit them as needed.
5. Click "Publish release". The GitHub Actions workflow will automatically build and push the new bot Docker images to Docker Hub.
6. Consider whether bot authors need to know about any changes to the image (e.g. dependencies).

Note: The reason for the prefix release version prefix (e.g. "bot-") is that the GitHub Actions workflow will use this prefix to determine which image to build and push.
