# Sets up ai-arena client
ARG PYTHON_VERSION=3.9
ARG SC2_VERSION=4.10
ARG VERSION_NUMBER=1.0.0
ARG USE_SQUASHED

FROM aiarena/sc2-linux-base:py_$PYTHON_VERSION-sc2_$SC2_VERSION-v$VERSION_NUMBER$USE_SQUASHED
MAINTAINER AI Arena <staff@aiarena.net>

WORKDIR /root/

# Prevent caching unless client master branch changed
# https://codehunter.cc/a/git/how-to-prevent-dockerfile-caching-git-clone
ADD https://api.github.com/repos/aiarena/aiarena-client/git/refs/heads/master version.json
RUN rm version.json

# Download python requirements files
ADD https://raw.githubusercontent.com/aiarena/aiarena-client/master/requirements.txt client-requirements.txt

# Add local pyproject.toml and poetry.lock which contain bot requirements
COPY pyproject.toml poetry.lock ./

# Merge client and bot requirements into pyproject.toml, generate a requirements.txt and install the packages globally
RUN pip install poetry
# Allows the final remove virtual env command
RUN poetry config virtualenvs.in-project true
# Merge client requirements into current requirements
RUN poetry add $(cat client-requirements.txt)
# Export unified requirements as requirements.txt, this will not include dev dependencies
RUN poetry export -f requirements.txt --output requirements.txt --without-hashes
# Remove virtual environment
RUN pip uninstall -y poetry
RUN rm -rf .venv
# Install requirements.txt globally
RUN pip install -r requirements.txt

# Download the aiarena client to /root/aiarena-client
# https://stackoverflow.com/a/3946745/10882657
RUN wget --quiet --show-progress --progress=bar:force https://github.com/aiarena/aiarena-client/archive/refs/heads/master.zip \
    && unzip -q master.zip \
    && mv aiarena-client-master aiarena-client \
    && rm master.zip

# Create bot users
RUN useradd -ms /bin/bash bot_player1 \
    && useradd -ms /bin/bash bot_player2

# Create Bot and Replay directories
RUN mkdir -p /root/aiarena-client/Bots \
    && mkdir -p /root/aiarena-client/Replays

# Change to working directory
WORKDIR /root/aiarena-client/

# Add Pythonpath to env
ENV PYTHONPATH=/root/aiarena-client/:/root/aiarena-client/arenaclient/
ENV HOST=0.0.0.0

# Install the arena client as a module
RUN python /root/aiarena-client/setup.py install

# Run the match runner
ENTRYPOINT [ "timeout", "120m", "/usr/local/bin/python3.9", "-m", "arenaclient" ]
