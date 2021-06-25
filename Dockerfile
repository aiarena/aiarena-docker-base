# Sets up ai-arena client

FROM aiarena/sc2-linux-base:latest
MAINTAINER AI Arena <staff@aiarena.net>

# Create a symlink for the maps directory
# Remove the Maps that come with the SC2 client
RUN ln -s /root/StarCraftII/Maps /root/StarCraftII/maps && rm -Rf /root/StarCraftII/maps/*

# Calls for a random number to break the cahing of the git clone
# (https://stackoverflow.com/questions/35134713/disable-cache-for-specific-run-commands/58801213#58801213)
ADD "https://www.random.org/cgi-bin/randbyte?nbytes=10&format=h" skipcache

# Download python requirements files
RUN wget https://github.com/aiarena/aiarena-client/raw/master/requirements.txt -O client-requirements.txt
COPY requirements.txt bot-requirements.txt

# Install python modules
RUN pip3.9 install -r client-requirements.txt && pip3.9 install -r bot-requirements.txt

# Download the aiarena client
RUN git clone https://github.com/aiarena/aiarena-client.git aiarena-client

# Create bot users
# Create Bot and Replay directories
RUN useradd -ms /bin/bash bot_player1 && useradd -ms /bin/bash bot_player2 && mkdir -p /root/aiarena-client/Bots && mkdir -p /root/aiarena-client/Replays

# Change to working directory
WORKDIR /root/aiarena-client/

# Add Pythonpath to env
ENV PYTHONPATH=/root/aiarena-client/:/root/aiarena-client/arenaclient/
ENV HOST 0.0.0.0

# Install the arena client as a module
RUN python3.9 /root/aiarena-client/setup.py install

# Add Pythonpath to env
ENV PYTHONPATH=/root/aiarena-client/:/root/aiarena-client/arenaclient/

WORKDIR /root/aiarena-client/

# Run the match runner
ENTRYPOINT [ "timeout", "120m", "/usr/local/bin/python3.9", "-m", "arenaclient" ]
