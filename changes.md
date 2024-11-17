# 2023-11-15 (v0.4.0)
## SC2 Dockerfile changes:
### General:
- Upgraded base image to Debian Bookworm
## Bot Dockerfile changes:
### General:
- Upgraded base image to Debian Bookworm
### .NET:
- Added .NET 8
- Removed .NET 6
### Python:

### Python libraries
- No breaking changes
### NodeJS:
- Upgraded to v18

# 2023-05-15 (v0.3.0)
## Bot Dockerfile changes:
### General:
- Added ffmpeg, libsm6, libxext6 system packages
### .NET:
- Added ML.NET
### Python:
- Updated to Python 3.11
### Python libraries
- **aiohttp "^3.7.4" -> "^3.8.4"**
- attrs = "^21.4.0" -> "^23.1.0"
- burnysc2 = "^6.0.0" -> "^6.2.0"
- certifi = "^2022.5.18" -> "^2023.5.7"
- gym = "^0.23.1" -> "^0.26.2"
- h5py = "^3.6.0" -> "^3.8.0"
- keras = "^2.9.0" -> "^2.12.0"
- loguru = "^0.6.0" -> ">=0.6.0,<0.7.0"
- more-itertools = "^8.13.0" -> "^9.1.0"
- multidict = "^6.0.2" ->  "^6.0.4"
- **numpy = "1.22.4" -> ">=1.22,<1.24"** 
- opencv-contrib-python = "^4.5.5" -> "^4.7.0"
- opencv-python = "^4.5.5" -> "^4.7.0"
- pipenv = "^2022.5.2" -> "^2023.5.19"
- pygame = "^2.4.0"
- python-utils = "^3.2.3" -> "^3.5.2"
- requests = "^2.27.1" -> "^2.30.1"
- **scikit-image = "^0.19.2" -> "^0.20.0"** 
- **scikit-learn = "^1.1.1" -> "^1.2.0"**
- scipy = "^1.8.1" -> "^1.10.1"
- sqlalchemy = "^1.4.36" -> "^1.4.48"
- **tensorflow = "^2.9.0" -> "^2.12.0"**
- **torch = "1.11.0" -> "^2.0.1"**
- **torchvision = "^0.12.0" -> "^0.15.0"**
- urllib3 = "^1.26.9" -> "^1.26.15"
- uvloop = "^0.16.0" -> "^0.17.0"
- virtualenv = "^20.14.1" -> "^20.23.0"
- websockets = "^10.3" -> "^11.0"
- yarl = "^1.7.2" -> "^1.9.2"