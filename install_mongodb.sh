#!/bin/bash
LOGFILE=/tmp/install_mongodb.log

pushd $HOME

# Installing MongoDB
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927 >> $LOGFILE 2>&1 
sudo bash -c 'echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.2.list' >> $LOGFILE 2>&1

sudo apt update >> $LOGFILE 2>&1
sudo apt install -y mongodb-org >> $LOGFILE 2>&1 

# Starting MongoDB
sudo sudo systemctl start mongod >> $LOGFILE 2>&1
sudo systemctl enable mongod >> $LOGFILE 2>&1

popd
