kubernetes:
  pkgrepo.managed:
    - humanname: kubernetes
# TODO: automatically trusting the repo is a terrible idea, figure out how to add signed-by argument instead. Ideally this is managed by the Kubernetes Salt Extension
    - name: deb [trusted=yes] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /
    - file: /etc/apt/sources.list.d/kubernetes.list
    - keyserver: https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.31/deb/Release.key
    - keyid: DE15B14486CD377B9E876E1A234654DA9A296436
    - clean_file: True
    - require.in:
      - pkg: kubeadm

  pkg.installed:
    - pkgs:
      - kubeadm
      - kubelet
      - kubectl
      - containerd

"cp /vagrant/files/config.toml /etc/containerd/config.toml":
  cmd.run

"mkdir /etc/default ; echo \"KUBELET_EXTRA_ARGS=--node-ip=$(ip route | grep eth1 | awk '{ print $9 }')\" > /etc/default/kubelet":
  cmd.run

"echo 1 > /proc/sys/net/ipv4/ip_forward":
  cmd.run

'echo -e "overlay\nbr_netfilter" > /etc/modules-load.d/k8s.conf':
  cmd.run

"modprobe overlay ; modprobe br_netfilter":
  cmd.run

'echo -e "net.bridge.bridge-nf-call-ip6tables = 1\nnet.bridge.bridge-nf-call-iptables = 1\nnet.ipv4.ip_forward = 1" > /etc/sysctl.d/k8s.conf':
  cmd.run

"sysctl --system":
  cmd.run

"systemctl restart kubelet containerd":
  cmd.run