# Sets up ai-arena client

FROM python:3.8.5-slim
MAINTAINER m1ndgames <m1nd@ai-arena.net>

USER root
WORKDIR /root/

RUN dpkg --add-architecture i386

# Update system
RUN apt-get update && apt-get upgrade --assume-yes --quiet=2

# Install common software via APT
RUN apt-get install --assume-yes --no-install-recommends --no-show-upgraded \
    git  \
    make \
    gcc \
    tree \
    unzip \
    wget \
    gpg \
    python-dev \
    procps \
    lsof \
    apt-transport-https \
    libgtk2.0-dev \
    software-properties-common \
    dirmngr \
    gpg-agent

# Add the microsoft repo for dotnetcore
RUN wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.asc.gpg && \
    mv microsoft.asc.gpg /etc/apt/trusted.gpg.d/ && \
    wget -q https://packages.microsoft.com/config/debian/9/prod.list && \
    mv prod.list /etc/apt/sources.list.d/microsoft-prod.list && \
    chown root:root /etc/apt/trusted.gpg.d/microsoft.asc.gpg && \
    chown root:root /etc/apt/sources.list.d/microsoft-prod.list

# Install Zulu Repo for openjdk-12
RUN apt-key adv --keyserver pgp.mit.edu --recv B1998361219BD9C9
RUN add-apt-repository 'deb http://repos.azulsystems.com/debian stable main'

# Update APT cache
RUN apt-get update

# Needed for Java install
RUN mkdir -p /usr/share/man/man1

# Install software via APT
# zulu-12 is java
RUN apt-get install --assume-yes --no-install-recommends --no-show-upgraded \
    zulu-12 \
    wine32 \
    dotnet-sdk-2.2

# Upgrade pip and install pip-install requirements
RUN python3 -m pip install --upgrade pip pipenv

# Download python requirements files
RUN wget https://gitlab.com/aiarena/aiarena-client/raw/master/requirements.linux.txt -O client-requirements.txt
RUN wget https://gitlab.com/aiarena/aiarena-client-provisioning/raw/master/aiarena-vm/templates/python-requirements.txt.j2 -O bot-requirements.txt

# Install python modules
RUN pip3.7 install -r client-requirements.txt
RUN pip3.7 install -r bot-requirements.txt

# Create aiarena user and change workdir/user
RUN useradd -ms /bin/bash aiarena
WORKDIR /home/aiarena/
USER aiarena
ENV PATH $PATH

# Copy the run file
COPY run.sh /home/aiarena/run.sh

# Download the aiarena client
RUN wget https://gitlab.com/aiarena/aiarena-client/-/archive/master/aiarena-client-master.tar.gz && tar xvzf aiarena-client-master.tar.gz && mv aiarena-client-master aiarena-client

# Copy the config file
COPY example_config.py /home/aiarena/aiarena-client/arenaclient/config.py

# Download and uncompress StarCraftII from https://github.com/Blizzard/s2client-proto#linux-packages and remove zip file
RUN wget -q 'http://blzdistsc2-a.akamaihd.net/Linux/SC2.4.10.zip' \
    && unzip -P iagreetotheeula SC2.4.10.zip \
    && rm SC2.4.10.zip

# Create a symlink for the maps directory
RUN ln -s /home/aiarena/StarCraftII/Maps /home/aiarena/StarCraftII/maps

# Remove the Maps that come with the SC2 client
RUN rm -Rf /home/aiarena/StarCraftII/maps/*

# Download and install the Map Pack
RUN wget -q 'http://blzdistsc2-a.akamaihd.net/MapPacks/Ladder2019Season3.zip' \
    && unzip -P iagreetotheeula Ladder2019Season3.zip \
    && rm Ladder2019Season3.zip

RUN mv Ladder2019Season3 /home/aiarena/StarCraftII/Maps
RUN cp /home/aiarena/StarCraftII/Maps/Ladder2019Season3/* /home/aiarena/StarCraftII/Maps

# Create Bot and Replay directories
RUN mkdir -p /home/aiarena/StarCraftII/Bots
RUN mkdir -p /home/aiarena/StarCraftII/Replays

# Switch User
USER root
#RUN chmod +x /home/aiarena/run.sh

RUN apt-get install --assume-yes --no-install-recommends --no-show-upgraded libgtk2.0-dev

# Change to working directory
WORKDIR /home/aiarena/aiarena-client

# Add Pythonpath to env
ENV PYTHONPATH=/home/aiarena/aiarena-client/:/home/aiarena/aiarena-client/arenaclient/
ENV HOST 0.0.0.0

# Install the arena client as a module
RUN python3.7 /home/aiarena/aiarena-client/setup.py install

# Switch User
USER aiarena

# Add Pythonpath to env
ENV PYTHONPATH=/home/aiarena/aiarena-client/:/home/aiarena/aiarena-client/arenaclient/

# Setup the config file
RUN echo '{"bot_directory_location": "/home/aiarena/StarCraftII/Bots", "sc2_directory_location": "/home/aiarena/StarCraftII/", "replay_directory_location": "/home/aiarena/StarCraftII/Replays", "API_token": "", "max_game_time": "60486", "allow_debug": "Off", "visualize": "Off"}' > /home/aiarena/aiarena-client/arenaclient/proxy/settings.json

WORKDIR /home/aiarena/aiarena-client/arenaclient

# Run the match runner gui
ENTRYPOINT [ "/home/aiarena/run.sh" ]
