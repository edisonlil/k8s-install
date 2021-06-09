#!/usr/bin/env bash

#sudo apt-cache madison $1

function add_sources() {

  curl https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | apt-key add -

  cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
  deb https://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main
EOF

  apt-get update -y
}


function install_k8s() {

 if test -z $K8S_VERSION; then
   #为空使用默认版本
   K8S_VERSION=`apt-cache madison kubelet kubeadm kubectl | grep kubeadm | awk 'NR==1{print $2}'`
 fi
 apt-get install -y kubeadm=$K8S_VERSION kubectl=$K8S_VERSION kubelet=$K8S_VERSION && systemctl enable --now kubelet
}

add_sources
install_k8s