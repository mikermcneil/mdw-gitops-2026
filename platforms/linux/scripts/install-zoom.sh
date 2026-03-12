#!/bin/bash
# install-zoom.sh
# Install Zoom on Debian-based Linux hosts

sudo dpkg -i zoom_amd64.deb && sudo apt-get install -f -y
