#!/bin/bash
# Script to run the PyQt5 application with proper X11 forwarding

# $1 may be empty, then predefined task is started else it is what one defines

# Set image name - replace with your image name
IMAGE_NAME="hapdocker/promo2025"
cd ..
LOCAL_ONTOLOGY_REPOSITORY=$(pwd)
DOKER_ONTOLOGY_REPOSITORY="/Ontology_Repository"
BASH=$1

# Enable X11 access for Docker (Linux only)
if [ "$(uname)" == "Linux" ]; then
  echo "Enabling X11 access for Docker..."
  xhost +local:docker
fi

# Determine correct DISPLAY setting based on OS
if [ "$(uname)" == "Darwin" ]; then
  # macOS with XQuartz
  DISPLAY_ENV="host.docker.internal:0"
  IP=$(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}')
  echo "Make sure XQuartz is running and you've run: xhost + $IP"
elif [ "$(uname)" == "Linux" ]; then
  # Linux
  DISPLAY_ENV="$DISPLAY"
else
  # Windows/other (assuming using X server like VcXsrv)
  DISPLAY_ENV="host.docker.internal:0"
  echo "Make sure your X server is running with 'Disable access control' checked"
fi

# Run the docker container
echo "Running PyQt5 application with display: $DISPLAY_ENV"
docker run --rm -it \
  -e DISPLAY=$DISPLAY_ENV \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v $LOCAL_ONTOLOGY_REPOSITORY:$DOKER_ONTOLOGY_REPOSITORY \
  --network=host \
  $IMAGE_NAME $1

# Cleanup X11 access (Linux only)
if [ "$(uname)" == "Linux" ]; then
  echo "Resetting X11 access..."
  xhost -local:docker
fi
