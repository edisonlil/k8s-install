#!/usr/bin/env bash

function uninstall_docker_packages() {
    sudo apt-get remove docker docker-engine docker.io containerd runc
}

function add_gpg_key() {
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpgku
}

function set_stable_version() {
  echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
}

function install_docker() {
  if [[ -z $DOCKER_VERSION ]]
  then
    sudo apt-get install docker-ce docker-ce-cli containerd.io
  else
   sudo apt-get install docker-ce=$DOCKER_VERSION docker-ce-cli=$DOCKER_VERSION containerd.io
  fi
}

function init_docker() {
    systemctl enable docker.service
    systemctl start docker.service
    systemctl stop docker.service
    echo '{"registry-mirrors": ["https://4xr1qpsp.mirror.aliyuncs.com"]}' > /etc/docker/daemon.json
    systemctl daemon-reload
    systemctl start docker
}


add_gpg_key
set_stable_version
install_docker
init_docker
docker version