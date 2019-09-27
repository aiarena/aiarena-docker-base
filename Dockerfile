# Sets up ai-arena client

FROM python:3.7-slim
MAINTAINER m1ndgames <m1nd@ai-arena.net>

# Set build Arguments
ARG CLIENTID=000
ARG APITOKEN=000

USER root
WORKDIR /root/

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
    apt-transport-https

# Add the microsoft repo for dotnetcore
RUN wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.asc.gpg && \
    mv microsoft.asc.gpg /etc/apt/trusted.gpg.d/ && \
    wget -q https://packages.microsoft.com/config/debian/9/prod.list && \
    mv prod.list /etc/apt/sources.list.d/microsoft-prod.list && \
    chown root:root /etc/apt/trusted.gpg.d/microsoft.asc.gpg && \
    chown root:root /etc/apt/sources.list.d/microsoft-prod.list

# Update APT cache
RUN apt-get update

# Needed for Java install
RUN mkdir -p /usr/share/man/man1

# Install software via APT
RUN apt-get install --assume-yes --no-install-recommends --no-show-upgraded \
    openjdk-11-jdk \
    wine \
    dotnet-sdk-3.0

# Upgrade pip and install pip-install requirements
RUN python3 -m pip install --upgrade pip pipenv

# Download python requirements files
RUN wget https://gitlab.com/aiarena/aiarena-client/raw/master/requirements.txt -O client-requirements.txt
RUN wget https://gitlab.com/aiarena/aiarena-client-provisioning/raw/master/aiarena-vm/templates/python-requirements.txt.j2 -O bot-requirements.txt

# Install python modules
RUN pip3 install -r client-requirements.txt
RUN pip3 install -r bot-requirements.txt

# Create aiarena user and change workdir/user
RUN useradd -ms /bin/bash aiarena
WORKDIR /home/aiarena/
USER aiarena

# Download the aiarena client
RUN wget https://gitlab.com/aiarena/aiarena-client/-/archive/master/aiarena-client-master.tar.gz && tar xvzf aiarena-client-master.tar.gz && mv aiarena-client-master aiarena-client

# Move the config
RUN mv aiarena-client/default_config.py aiarena-client/config.py

RUN echo $APITOKEN

# Change the Client ID
RUN sed -i 's/aiarenaclient_000/$CLIENTID/g' aiarena-client/config.py

# Change the API Token
RUN sed -i 's/\?\?\?/$APITOKEN/g' aiarena-client/config.py

# Download and uncompress StarCraftII from https://github.com/Blizzard/s2client-proto#linux-packages and remove zip file
RUN wget -q 'http://blzdistsc2-a.akamaihd.net/Linux/SC2.4.10.zip' \
    && unzip -P iagreetotheeula SC2.4.10.zip \
    && rm SC2.4.10.zip

# Create a symlink for the maps directory
RUN ln -s /home/aiarena/StarCraftII/Maps /home/aiarena/StarCraftII/maps

# Remove the Maps that come with the SC2 client
RUN rm -Rf /home/aiarena/StarCraftII/maps/*

ENTRYPOINT [ "/bin/bash" ]
