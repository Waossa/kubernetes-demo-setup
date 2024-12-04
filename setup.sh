#!/usr/bin/env bash

set -euo pipefail

echo "==> Spin up the VMs and bootstrap Salt"
vagrant up

echo "==> Restart VMs (to apply changes after disabling swap)"
vagrant reload

echo "==> Initialize cluster, starting with control-plane node"
vagrant ssh control-plane -c "sudo /vagrant/initscript-control.sh"

echo "==> Setup worker nodes and install Kubernetes on them"
echo "==> node-01..."
vagrant ssh node-01 -c "sudo /vagrant/initscript-worker.sh"
echo "==> node-02..."
vagrant ssh node-02 -c "sudo /vagrant/initscript-worker.sh"

echo "==> acquire join token from control-plane"
joincmd="sudo $(vagrant ssh control-plane -c 'sudo kubeadm token create --print-join-command' | tail -n 1)"
token=$(echo $joincmd | awk '{print $6}')
discovery_token=$(echo $joincmd | awk '{print $8}')
#echo "token: $token"
#echo "discovery: $discovery_token"

echo "==> Join node-01 to the worker pool"
vagrant ssh node-01 -c "sudo kubeadm join 192.168.56.11:6443 --token $token --discovery-token-ca-cert-hash $discovery_token"
echo "==> Join node-02 to the worker pool"
vagrant ssh node-02 -c "sudo kubeadm join 192.168.56.11:6443 --token $token --discovery-token-ca-cert-hash $discovery_token"

echo "==> Deploy sample application stack"
vagrant ssh control-plane -c "sudo kubectl --kubeconfig=/etc/kubernetes/admin.conf apply -f /vagrant/files/sample-stack.yaml"
