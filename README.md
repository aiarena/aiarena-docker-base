# aiarena-docker

## Build

`docker build .`

## Configure

Create your config based off [example_config.py](./example_config.py)  
Make sure you set your client id, api token, and website url.

## Run
`docker run -it -d -v /path/to/your/config.py:/root/aiarena-client/config.py --restart=unless-stopped <container-id>`