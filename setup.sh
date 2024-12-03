#!/usr/bin/env bash

set -euo pipefail

vagrant up
vagrant reload
vagrant ssh control-plane -c "sudo /vagrant/initscript-control.sh"
vagrant ssh node-01 -c "sudo /vagrant/initscript-worker.sh"
vagrant ssh node-02 -c "sudo /vagrant/initscript-worker.sh"
joincmd="sudo $(vagrant ssh control-plane -c 'sudo kubeadm token create --print-join-command' | tail -n 1)"
token=$(echo $joincmd | awk '{print $6}')
discovery_token=$(echo $joincmd | awk '{print $8}')
echo "token: $token"
echo "discovery: $discovery_token"
vagrant ssh node-01 -c "sudo kubeadm join 192.168.56.11:6443 --token $token --discovery-token-ca-cert-hash $discovery_token"
vagrant ssh node-02 -c "sudo kubeadm join 192.168.56.11:6443 --token $token --discovery-token-ca-cert-hash $discovery_token"
