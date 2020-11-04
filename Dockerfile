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
RUN wget https://gitlab.com/aiarena/aiarena-client-provisioning/raw/master/aiarena-vm/templates/python-requirements.txt.j2 -O bot-requirements.txt

# Install python modules
RUN pip3.7 install -r client-requirements.txt
RUN pip3.7 install -r bot-requirements.txt

# Create aiarena user and change workdir/user
RUN useradd -ms /bin/bash aiarena
WORKDIR /home/aiarena/
ENV PATH $PATH

# Copy the config file
COPY example_config.py /home/aiarena/aiarena-client/arenaclient/config.py

# Copy and uncompress StarCraftII and remove zip file
COPY cache/SC2.4.10.zip /home/aiarena/SC2.4.10.zip
RUN unzip -P iagreetotheeula SC2.4.10.zip \
    && rm SC2.4.10.zip

# Create a symlink for the maps directory
RUN ln -s /home/aiarena/StarCraftII/Maps /home/aiarena/StarCraftII/maps

# Remove the Maps that come with the SC2 client
RUN rm -Rf /home/aiarena/StarCraftII/maps/*

# Copy and install the Map Pack
COPY cache/maps.zip /home/aiarena/maps.zip
RUN unzip maps.zip \
    && rm maps.zip

RUN cp /home/aiarena/maps/* /home/aiarena/StarCraftII/Maps
RUN rm -Rf maps

# Create Bot and Replay directories
RUN mkdir -p /home/aiarena/aiarena-client/Bots
RUN mkdir -p /home/aiarena/aiarena-client/Replays

RUN apt-get install --assume-yes --no-install-recommends --no-show-upgraded libgtk2.0-dev

# Change to working directory
WORKDIR /home/aiarena/aiarena-client

# Add Pythonpath to env
ENV PYTHONPATH=/home/aiarena/aiarena-client/:/home/aiarena/aiarena-client/arenaclient/
ENV HOST 0.0.0.0

# Install the arena client as a module
RUN python3.7 /home/aiarena/aiarena-client/setup.py install

# Install nodejs
RUN wget https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install -y nodejs

# Add Pythonpath to env
ENV PYTHONPATH=/home/aiarena/aiarena-client/:/home/aiarena/aiarena-client/arenaclient/

# Copy the config file
COPY example_config.py /home/aiarena/aiarena-client/config.py

# Install SC2MapAnalysis
WORKDIR /home/aiarena/
COPY cache/SC2MapAnalysis-master.zip /home/aiarena/SC2MapAnalysis-master.zip
RUN unzip SC2MapAnalysis-master.zip
WORKDIR /home/aiarena/SC2MapAnalysis-master
RUN pip3 install .

# Download the aiarena client
CACHE-OFF
RUN wget https://github.com/aiarena/aiarena-client/archive/master.tar.gz && tar xvzf aiarena-client-master.tar.gz && mv aiarena-client-master aiarena-client

WORKDIR /home/aiarena/aiarena-client/

# Run the match runner
ENTRYPOINT [ "timeout", "120m", "/usr/local/bin/python3.7", "-m", "arenaclient" ]
