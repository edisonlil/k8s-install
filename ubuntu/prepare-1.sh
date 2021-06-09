#!/usr/bin/env bash

function check_command() {
   echo $(command_path=`command -v $1` && echo "true" || echo "false")
}

function set_hostname() {
 echo $MASTER_HOST_NAME > /etc/hostname
 echo "127.0.0.1 $MASTER_HOST_NAME" >> /etc/hosts
}

function shut_firewall() {

  if test $(check_command "ufw") == "true"
  then
    sudo ufw disable
  fi
}

function shut_swap() {
 echo "vm.swappiness = 0">> /etc/sysctl.conf
 swapoff -a && swapon -a && swapoff -a
}


echo "--------------------------------準備環境-------------------------------------"

#设置主机名
set_hostname
#关闭防火墙
shut_firewall
#关闭交换内存
shut_swap

sudo apt-get update -y

sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release