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

 version=$K8S_VERSION
 if test -z $version; then
   #为空使用默认版本
   version=`apt-cache madison kubelet kubeadm kubectl | grep kubeadm | awk 'NR==1{print $3}'`
   apt-get install -y kubeadm=$version kubectl=$version kubelet=$version && systemctl enable --now kubelet
   export K8S_VERSION=`echo $version | sed "s/-00//g"`
 else
   version="${version:1}-00"
   apt-get install -y kubeadm=$version kubectl=$version kubelet=$version && systemctl enable --now kubelet
 fi

}

add_sources
install_k8s
