
echo "-------------------------------初始化主節點-------------------------------------"

kubeadm init \
 --apiserver-advertise-address $MASTER_IP \
 --kubernetes-version=$K8S_VERSION \
 --pod-network-cidr=10.244.0.0/16

export KUBECONFIG=/etc/kubernetes/admin.conf

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

