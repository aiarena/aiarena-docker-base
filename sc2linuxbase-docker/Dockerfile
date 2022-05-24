# Set python version
ARG PYTHON_VERSION=3.9

FROM python:$PYTHON_VERSION-slim
MAINTAINER AI Arena <staff@aiarena.net>

# Set sc2 version
ARG SC2_VERSION=4.10

USER root
WORKDIR /root/

# Update system
RUN dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get upgrade --assume-yes --quiet=2 \
    && apt-get install --assume-yes --no-install-recommends --no-show-upgraded \
    wget \
    unzip

# Download and uncompress StarCraftII from https://github.com/Blizzard/s2client-proto#linux-packages and remove zip file
# If file is locally available, use this instead:
#COPY SC2.4.10.zip /root/
RUN wget --quiet --show-progress --progress=bar:force http://blzdistsc2-a.akamaihd.net/Linux/SC2.$SC2_VERSION.zip \
    && unzip -q -P iagreetotheeula SC2.$SC2_VERSION.zip \
    && rm SC2.$SC2_VERSION.zip

# Remove Battle.net folder
RUN rm -rf /root/StarCraftII/Battle.net/* \
    # Remove Shaders folder
    && rm -rf /root/StarCraftII/Versions/Shaders*

# Create a symlink for the maps directory
RUN ln -s /root/StarCraftII/Maps /root/StarCraftII/maps \
    # Remove the Maps that come with the SC2 client
    && rm -rf /root/StarCraftII/maps/*

# Install common software
RUN apt-get install --assume-yes --no-install-recommends --no-show-upgraded \
    git  \
    make \
    gcc \
    tree \
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

# Prepare NET 5.0 installation
ADD https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb \
    && rm packages-microsoft-prod.deb \
    && apt-get update

# Add NET 5.0 runtime
RUN apt-get install -y dotnet-runtime-5.0

# Prepare NET 6.0 installation
ADD https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb \
    && rm packages-microsoft-prod.deb \
    && apt-get update

# Add NET 6.0 runtime
# https://docs.microsoft.com/en-us/dotnet/core/install/linux-ubuntu#2204
# Don't install aspnetcore-runtime
RUN apt-get install -y dotnet-runtime-6.0

# Install Zulu Repo for openjdk-12
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0xB1998361219BD9C9 \
    && add-apt-repository 'deb http://repos.azulsystems.com/debian stable main' \
    && apt-get update

# Needed for Java install
RUN mkdir -p /usr/share/man/man1

# Install nodejs
RUN apt-get install --assume-yes --no-install-recommends --no-show-upgraded npm

# Install wine
RUN apt-get install --assume-yes --no-install-recommends --no-show-upgraded wine32

# Upgrade python pip
RUN pip install --upgrade pip

# Install Zulu for Java 16
RUN wget --quiet --show-progress --progress=bar:force https://cdn.azul.com/zulu/bin/zulu16.30.15-ca-jre16.0.1-linux_amd64.deb \
    && apt-get install --assume-yes ./zulu16.30.15-ca-jre16.0.1-linux_amd64.deb \
    && rm ./zulu16.30.15-ca-jre16.0.1-linux_amd64.deb
