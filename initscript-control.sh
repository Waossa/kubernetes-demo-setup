
cp -r /vagrant/files/control-node /srv/salt
salt-call --local state.apply

kubeadm init --apiserver-advertise-address=192.168.56.11 --pod-network-cidr=10.244.0.0/16
kubectl --kubeconfig=/etc/kubernetes/admin.conf apply -f https://github.com/flannel-io/flannel/releases/download/v0.26.1/kube-flannel.yml
