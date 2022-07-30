# Set python version
ARG PYTHON_VERSION=3.9

FROM python:$PYTHON_VERSION-slim
MAINTAINER AI Arena <staff@aiarena.net>

# Set sc2 version
ARG SC2_VERSION=4.10

# Debugging purposes
RUN echo $PYTHON_VERSION
RUN echo $SC2_VERSION

USER root
WORKDIR /root/

# Update system
RUN apt-get update \
    && apt-get upgrade --assume-yes --quiet=2 \
    && apt-get install --assume-yes --no-install-recommends --no-show-upgraded \
    wget \
    unzip \
    gnupg2 \
    software-properties-common \
    libosmesa6-dev \
    git

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

# Needed for Java install
RUN mkdir -p /usr/share/man/man1

# Install Zulu Repo for openjdk-12
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0xB1998361219BD9C9 \
    && add-apt-repository 'deb http://repos.azulsystems.com/debian stable main' \
    && apt-get update

# Install Zulu for Java 17
RUN wget --quiet --show-progress --progress=bar:force https://cdn.azul.com/zulu/bin/zulu17.36.13-ca-jre17.0.4-linux_amd64.deb \
    && apt-get install --assume-yes ./zulu17.36.13-ca-jre17.0.4-linux_amd64.deb \
    && rm ./zulu17.36.13-ca-jre17.0.4-linux_amd64.deb

# Prepare NET installation
ADD https://packages.microsoft.com/config/debian/11/packages-microsoft-prod.deb packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb \
    && rm packages-microsoft-prod.deb \
    && apt-get update

# Add NET runtimes
RUN apt-get install --assume-yes dotnet-runtime-5.0 dotnet-runtime-6.0

# Install nodejs
RUN apt-get install --assume-yes --no-install-recommends --no-show-upgraded npm


# Upgrade python pip
RUN pip install --upgrade --no-cache-dir pip

RUN apt remove --yes gnupg2 \
    software-properties-common\ 
    && apt autoremove --yes
