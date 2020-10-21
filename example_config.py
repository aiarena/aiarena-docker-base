from urllib import parse
from arenaclient.matches import HttpApiMatchSource

ARENA_CLIENT_ID = "???"
API_TOKEN = "???"
SHUT_DOWN_AFTER_RUN = True
ROUNDS_PER_RUN = 10
BASE_WEBSITE_URL = "http://host.docker.internal:8000"
API_MATCHES_URL = parse.urljoin(BASE_WEBSITE_URL, "/api/arenaclient/matches/")
API_RESULTS_URL = parse.urljoin(BASE_WEBSITE_URL, "/api/arenaclient/results/")
MATCH_SOURCE_CONFIG = HttpApiMatchSource.HttpApiMatchSourceConfig(api_url=BASE_WEBSITE_URL,api_token=API_TOKEN)


MAX_GAME_TIME = 60486000
MAX_FRAME_TIME = 1000000
STRIKES = 10000