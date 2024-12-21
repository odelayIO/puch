#!/bin/bash
#############################################################################################
#############################################################################################
#
#   The MIT License (MIT)
#   
#   Copyright (c) 2023 http://odelay.io 
#   
#   Permission is hereby granted, free of charge, to any person obtaining a copy
#   of this software and associated documentation files (the "Software"), to deal
#   in the Software without restriction, including without limitation the rights
#   to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#   copies of the Software, and to permit persons to whom the Software is
#   furnished to do so, subject to the following conditions:
#   
#   The above copyright notice and this permission notice shall be included in all
#   copies or substantial portions of the Software.
#   
#   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#   SOFTWARE.
#   
#   Contact : <everett@odelay.io>
#  
#   Description : This script to the Docker Container start script.  It is
#                 is assumed the system has vivado2022.1_docker image.
#                 See the following repo for more information:
#
#                  https://github.com/odelayIO/vivado2022.1_docker 
#
#   Version History:
#   
#       Date        Description
#     -----------   -----------------------------------------------------------------------
#      2023-04-18    Original Creation
#
###########################################################################################

export PROJECT_PATH=${PWD}
export DOCKER_HOME=/home/docker/puch-workspace

#-------------------------------------------------------------------------------
# Helper Function
#-------------------------------------------------------------------------------
helpFcn()
{
  echo ""
  echo "Usage: "
  echo -b "\t-d Base folder for project source code (default=$PROJECT_PATH)"
  echo -d "\t-d Docker container home directory (default=$DOCKER_HOME)"
  exit 1
}


while getopts "b:f:h" opt
do
  case "$opt" in 
    b) PROJECT_PATH="$OPTARG" ;;
    d) DOCKER_HOME="$OPTARG" ;;
    h) helpFcn ;;   # print helpFcn is -h is specified
  esac
done


#-------------------------------------------------------------------------------
#   Start the Docker Container
#-------------------------------------------------------------------------------
docker run -it --rm \
  --net host \
  -e PYTHONPATH=${DOCKER_HOME}/consair-reg-map \
  -e LOCAL_UID=$(id -u ${USER}) \
  -e LOCAL_GID=$(id -g ${USER}) \
  -e USER=${USER} \
  -e UART_GROUP_ID=20 \
  -e DISPLAY=${DISPLAY} \
  -e "QT_X11_NO_MITSHM=1" \
  -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
  -v ${HOME}/.Xauthority:${HOME}/.Xauthority:rw \
  -v ${PROJECT_PATH}:${DOCKER_HOME}:rw \
  -v /dev/bus/usb:/dev/bus/usb:rw \
  -v /sys:/sys:ro \
  --device /dev/dri \
  --privileged \
  -w ${DOCKER_HOME} \
  vivado:2022.1
