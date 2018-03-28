#!/bin/bash
LOGFILE=/tmp/install_ruby.log

pushd $HOME

# Updating APT and installing Ruby and Bundler
sudo apt update >> $LOGFILE 2>&1
sudo apt install -y ruby-full ruby-bundler build-essential

# Testing Ruby and Bundler installs
ruby -v >> $LOGFILE 2>&1 
bundle -v >> $LOGFILE 2>&1 

popd
