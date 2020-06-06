#!/usr/bin/env bash

set -o errtrace
set -o errexit
set -o pipefail

GIT_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

detect_distro()
{
        local NAME=
        local VERSION=
        local ID=
        if [ -f /etc/os-release ]; then
                . /etc/os-release
                echo $NAME
        fi
}

case $(detect_distro) in
"Arch Linux")
        echo "Arch Linux detected, installing dependencies with pacman..."
        sudo pacman --quiet -S chromium nodejs npm
        ;;
"Ubuntu")
        echo "Ubuntu detected, installing dependencies with apt..."
        sudo apt install chromium-browser nodejs npm
        ;;
*)
        echo "Couldn't recognize Linux distribution, aborting..."
        exit
        ;;
esac

echo "Installing WebLiero Headless Launcher with npm..."
sudo NPM_CONFIG_UNSAFE_PERM=true npm install -g https://gitlab.com/basro/webliero-headless-launcher.git

echo "Creating system folders in home..."
mkdir -p ~/wlhl-scripts ~/.config/systemd/user ~/.local/bin

echo "Copying system scripts..."
cp $GIT_ROOT/server/wlhl-server.service ~/.config/systemd/user
cp $GIT_ROOT/server/wlhl-server ~/.local/bin/wlhl-server
chmod +x ~/.local/bin/wlhl-server

echo "Enabling and starting wlhl-server service..."
systemctl --user enable wlhl-server
systemctl --user start wlhl-server

# Cleanup
rm -rf $GIT_ROOT
