#!/usr/bin/env bash

set -o errtrace
set -o errexit
set -o pipefail

mkdir ~/bin
mkdir ~/log
mkdir ~/tmp
mkdir ~/wlhl-scripts

cd bin

wget https://raw.githubusercontent.com/pilaf/webliero-headless/master/scripts/wlhl-server-start
wget https://raw.githubusercontent.com/pilaf/webliero-headless/master/scripts/wlhl-server-stop
