#!/usr/bin/env bash

echo "--------------------------------下載鏡像-------------------------------------"

versions=`kubeadm config images list --kubernetes-version "v$K8S_VERSION"`
apiserver_version_tmp=`echo $versions | sed 's/ /\n/g'| grep k8s.gcr.io/kube-apiserver`
pause_version_tmp=`echo $versions | sed 's/ /\n/g'| grep k8s.gcr.io/pause`
etcd_version_tmp=`echo $versions | sed 's/ /\n/g'| grep k8s.gcr.io/etcd`
coredns_version_tmp=`echo $versions | sed 's/ /\n/g'| grep k8s.gcr.io/coredns`
apiserver_version=${apiserver_version_tmp#*:}
pause_version=${pause_version_tmp#*:}
etcd_version=${etcd_version_tmp#*:}
coredns_version=${coredns_version_tmp#*:}

KUBE_VERSION=$apiserver_version
KUBE_PAUSE_VERSION=$pause_version
ETCD_VERSION=$etcd_version
CORE_DNS_VERSION=$coredns_version


GCR_URL=k8s.gcr.io
ALIYUN_URL=registry.cn-hangzhou.aliyuncs.com/google_containers


images=(kube-proxy:${KUBE_VERSION}
kube-scheduler:${KUBE_VERSION}
kube-controller-manager:${KUBE_VERSION}
kube-apiserver:${KUBE_VERSION}
pause:${KUBE_PAUSE_VERSION}
etcd:${ETCD_VERSION}
coredns:${CORE_DNS_VERSION})

#解决coredns依赖镜像名不一样问题
coredns_images_name="coredns:${CORE_DNS_VERSION}"

for imageName in ${images[@]} ; do

  if [[ $coredns_images_name == $imageName ]]
  then
    docker pull "${ALIYUN_URL}/coredns:${CORE_DNS_VERSION:1}"
    docker tag  "${ALIYUN_URL}/coredns:${CORE_DNS_VERSION:1}" ${GCR_URL}/"coredns"/${imageName}
    docker rmi  "${ALIYUN_URL}/coredns:${CORE_DNS_VERSION:1}"
  else
    docker pull $ALIYUN_URL/$imageName
    docker tag  $ALIYUN_URL/$imageName $GCR_URL/$imageName
    docker rmi $ALIYUN_URL/$imageName
  fi
done
