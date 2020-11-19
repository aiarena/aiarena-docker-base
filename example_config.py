import os
from urllib import parse
from arenaclient.match.matches import HttpApiMatchSource

ARENA_CLIENT_ID = "???"
API_TOKEN = "???"
BASE_WEBSITE_URL = "???"

ROUNDS_PER_RUN = 1
API_MATCHES_URL = parse.urljoin(BASE_WEBSITE_URL, "/api/arenaclient/matches/")
API_RESULTS_URL = parse.urljoin(BASE_WEBSITE_URL, "/api/arenaclient/results/")
MATCH_SOURCE_CONFIG = HttpApiMatchSource.HttpApiMatchSourceConfig(api_url=BASE_WEBSITE_URL,api_token=API_TOKEN)

# Secure mode will ignore the BOTS_DIRECTORY config setting and instead run each bot in their home directory.
SECURE_MODE = True
# Specify the users (if any) to run the bots as.
RUN_PLAYER1_AS_USER = "bot_player1"
RUN_PLAYER2_AS_USER = "bot_player2"

# PATHS AND FILES
TEMP_PATH = "/tmp/aiarena/"
LOCAL_PATH = os.path.dirname(__file__)
WORKING_DIRECTORY = LOCAL_PATH  # same for now
LOG_FILE = os.path.join(WORKING_DIRECTORY, "aiarena-client.log")
REPLAYS_DIRECTORY = os.path.join(WORKING_DIRECTORY, "replays")
BOTS_DIRECTORY = os.path.join(WORKING_DIRECTORY, "bots")
SC2_HOME = "/root/StarCraftII/"
MAX_GAME_TIME = 80640