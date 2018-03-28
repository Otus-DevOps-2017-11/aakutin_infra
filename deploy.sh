#!/bin/bash
LOGFILE=/tmp/deploy.log

pushd $HOME
# Deploy reddit application
git clone https://github.com/Otus-DevOps-2017-11/reddit.git
pushd reddit
bundle install >> $LOGFILE 2>&1
puma -d >> $LOGFILE 2>&1
ps aux | grep puma >> $LOGFILE 2>&1

popd
