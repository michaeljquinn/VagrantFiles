#!/bin/bash
#
# Author:
#
# Version:
#
# Description:
#
# Usage:
#
# Copyright (C) 2018 Michael John Quinn - All Rights Reserved
# You may use, distribute and modify this code under the
# terms of the Apache 2.0 license

export DEBIAN_FRONTEND=noninteractive



loggerInfo() {
echo "**************************"
echo $1
echo "**************************"


}

forcetoIP4() {
    # need this for forcing to ip4
    loggerInfo "Forcing to IP 4 for ubuntu"
    sudo cp /etc/gai.conf /etc/gai.conf.orig
    sudo sed 's#\#precedence ::ffff:0:0/96  100#precedence ::ffff:0:0/96  100#' /etc/gai.conf.orig > /etc/gai.conf
}

basePackages() {
    loggerInfo  "Installing base packages"
    sudo apt-get update -y
    sudo apt-get install \
        apt-transport-https \
        ca-certificates \
        curl \
        software-properties-common \
        libc_bin \
        jq \
	autoremove \
        -y

    sudo apt-get update -y
}

installDocker() {
    loggerInfo  "Installing Docker"
    ###  for some docker keys so the following update will work
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo apt-get update -y
    apt-cache policy docker-ce
    sudo apt-get install -y docker-ce

    loggerInfo  "Installing docker-compose"
    sudo curl -L https://github.com/docker/compose/releases/download/1.17.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
}

# Default shell for mup must be bash
# https://github.com/zodern/meteor-up/issues/830
#
addUser() {
    local user=$1
    local passwd=$2
    loggerInfo  "Adding user $user"

    echo "Add ${user} and set password to ${passwd}"
    echo "Default shell for user must be bash !!"

    sudo useradd -p $(openssl passwd -1 ${passwd} ) -m ${user}
    loggerInfo "adding $user to docker group"
    sudo usermod -aG docker ${user}


    # set the user default shell to bash
    sudo usermod -s /bin/bash $user
    # add $user to sudoers file
    usermod -aG sudo ${user}
}

installGUI() {
    loggerInfo  "Adding user installing GUI desktop"
    echo "Install gnome and gui"
    sudo apt-get update
    sudo apt-get install --no-install-recommends ubuntu-desktop -y
}

# create public/private key pair for subsequent
# passwordless login for the $user

createKeyPair() {
    local user=$1
    echo "TBD : Creating key pair for user: ${user} "
}

updatePython() {
    sudo apt-get install -y python-pip python-dev build-essential
}
forcetoIP4
basePackages
updatePython
installDocker
addUser apidev password
createKeyPair apidev
#installGUI
