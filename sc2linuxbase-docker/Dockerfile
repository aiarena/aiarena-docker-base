# Set python version
ARG PYTHON_VERSION=3.9

FROM python:$PYTHON_VERSION-slim
MAINTAINER AI Arena <staff@aiarena.net>

# Set sc2 version
ARG SC2_VERSION=4.10

USER root
WORKDIR /root/

RUN dpkg --add-architecture i386

# Update system
RUN apt-get update && apt-get upgrade --assume-yes --quiet=2
RUN apt-get install --assume-yes --no-install-recommends --no-show-upgraded \
    wget \
    unzip

# Download and uncompress StarCraftII from https://github.com/Blizzard/s2client-proto#linux-packages and remove zip file
RUN wget -q http://blzdistsc2-a.akamaihd.net/Linux/SC2.$SC2_VERSION.zip \
    && unzip -P iagreetotheeula SC2.$SC2_VERSION.zip \
    && rm SC2.$SC2_VERSION.zip

# Install common software via APT
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

# Add the microsoft repo for dotnetcore prior to NET 5.0
RUN wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.asc.gpg && \
    mv microsoft.asc.gpg /etc/apt/trusted.gpg.d/ && \
    wget -q https://packages.microsoft.com/config/debian/9/prod.list && \
    mv prod.list /etc/apt/sources.list.d/microsoft-prod.list && \
    chown root:root /etc/apt/trusted.gpg.d/microsoft.asc.gpg && \
    chown root:root /etc/apt/sources.list.d/microsoft-prod.list

# Add NET 5.0 support
RUN wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb  && dpkg -i packages-microsoft-prod.deb && apt-get update && apt-get install -y apt-transport-https && apt-get update && apt-get install -y dotnet-sdk-5.0

# Install Zulu Repo for openjdk-12
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0xB1998361219BD9C9
RUN add-apt-repository 'deb http://repos.azulsystems.com/debian stable main'

# Update APT cache
RUN apt-get update

# Needed for Java install
RUN mkdir -p /usr/share/man/man1

# Install nodejs
RUN apt-get install --assume-yes --no-install-recommends --no-show-upgraded npm

# Install software via APT
RUN apt-get install --assume-yes --no-install-recommends --no-show-upgraded \
    wine32 \
    dotnet-sdk-6.0

# Upgrade pip
RUN python -m pip install --upgrade pip

# Install Zulu for Java 16
RUN wget -q https://cdn.azul.com/zulu/bin/zulu16.30.15-ca-jre16.0.1-linux_amd64.deb \
	&& apt install --assume-yes ./zulu16.30.15-ca-jre16.0.1-linux_amd64.deb \
	&& rm ./zulu16.30.15-ca-jre16.0.1-linux_amd64.deb