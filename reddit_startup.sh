#!/bin/bash
LOGFILE=/tmp/reddit_startup.log

pushd $HOME

# Updating APT and installing Ruby and Bundler
sudo apt update >> $LOGFILE 2>&1
sudo apt install -y ruby-full ruby-bundler build-essential

# Testing Ruby and Bundler installs
ruby -v >> $LOGFILE 2>&1 
bundle -v >> $LOGFILE 2>&1 

# Installing MongoDB
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927 >> $LOGFILE 2>&1 
sudo bash -c 'echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.2.list' >> $LOGFILE 2>&1

sudo apt update >> $LOGFILE 2>&1
sudo apt install -y mongodb-org >> $LOGFILE 2>&1 

# Starting MongoDB
sudo sudo systemctl start mongod >> $LOGFILE 2>&1
sudo systemctl enable mongod >> $LOGFILE 2>&1

# Deploy reddit application
git clone https://github.com/Otus-DevOps-2017-11/reddit.git
pushd reddit
bundle install >> $LOGFILE 2>&1
puma -d >> $LOGFILE 2>&1
ps aux | grep puma >> $LOGFILE 2>&1

popd
