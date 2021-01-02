#!/usr/bin/env fish

sudo -v
sudo ifconfig en0 down
sudo route flush
sudo ifconfig en0 up
