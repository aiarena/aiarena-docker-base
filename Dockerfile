# Sets up ai-arena client

FROM python:3.7-slim
MAINTAINER AI Arena <staff@aiarena.net>

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
    gpg-agent \
    g++

# Add the microsoft repo for dotnetcore
RUN wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.asc.gpg && \
    mv microsoft.asc.gpg /etc/apt/trusted.gpg.d/ && \
    wget -q https://packages.microsoft.com/config/debian/9/prod.list && \
    mv prod.list /etc/apt/sources.list.d/microsoft-prod.list && \
    chown root:root /etc/apt/trusted.gpg.d/microsoft.asc.gpg && \
    chown root:root /etc/apt/sources.list.d/microsoft-prod.list

# Install Zulu Repo for openjdk-12
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0xB1998361219BD9C9
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
RUN wget https://github.com/aiarena/aiarena-client/raw/master/requirements.txt -O client-requirements.txt
COPY requirements.txt bot-requirements.txt

# Install python modules
RUN pip3.7 install -r client-requirements.txt
RUN pip3.7 install -r bot-requirements.txt

# Create bot users
RUN useradd -ms /bin/bash bot_player1
RUN useradd -ms /bin/bash bot_player2

# Download and uncompress StarCraftII from https://github.com/Blizzard/s2client-proto#linux-packages and remove zip file
RUN wget -q 'http://blzdistsc2-a.akamaihd.net/Linux/SC2.4.10.zip' \
    && unzip -P iagreetotheeula SC2.4.10.zip \
    && rm SC2.4.10.zip

# Create a symlink for the maps directory
RUN ln -s /root/StarCraftII/Maps /root/StarCraftII/maps

# Remove the Maps that come with the SC2 client
RUN rm -Rf /root/StarCraftII/maps/*

# Download the aiarena client
RUN wget https://github.com/aiarena/aiarena-client/archive/master.tar.gz && tar xvzf master.tar.gz && mv aiarena-client-master aiarena-client

# Create Bot and Replay directories
RUN mkdir -p /root/aiarena-client/Bots
RUN mkdir -p /root/aiarena-client/Replays

RUN apt-get install --assume-yes --no-install-recommends --no-show-upgraded libgtk2.0-dev

# Change to working directory
WORKDIR /root/aiarena-client/

# Add Pythonpath to env
ENV PYTHONPATH=/root/aiarena-client/:/root/aiarena-client/arenaclient/
ENV HOST 0.0.0.0

# Install the arena client as a module
RUN python3.7 /root/aiarena-client/setup.py install

# Install nodejs
RUN wget https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install -y nodejs

# Add Pythonpath to env
ENV PYTHONPATH=/root/aiarena-client/:/root/aiarena-client/arenaclient/

WORKDIR /root/aiarena-client/

# Run the match runner
ENTRYPOINT [ "timeout", "120m", "/usr/local/bin/python3.7", "-m", "arenaclient" ]
