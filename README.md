# Full Kubernetes cluster setup using Vagrant

This is a playground for automating the kubernetes cluster setup.

## Description

The motivation for this repository was to practise Kubernetes installation, try out some new and old technologies, and have a sample application up and running in the cluster. Some inspiration was found from here: https://github.com/vancanhuit/vagrant-k8s but I didn't want to simply copy that setup, so instead I opted for SaltStack to set things up for k8s, and simple SSH commands for kubeadm functions after the installation is done.

## Known issues and shortcomings
1. While the sample applications are successfully deployed and they boot up without issue, there still remains some networking problems that prevent k8s services from obtaining a reachable IP address, thus rendering the services unavailable
2. The Salt configuration is rather rough. Individual commands listed there would be re-run if you were to re-apply the state. While this nicely overwrites files and avoids configuration drift, there probably exists better ways to do that. Ideally the whole kubernetes setup would probably be handled by the appropriate Salt Extension but again, I wanted to figure out the necessary steps myself.

## Getting Started

Simply run the `setup.sh` in project root for full setup. The script is not resilent for occasional connectivity issues, for example with apt repositories, you can just re-run it if errors arise, assuming the `kubeadm init` has not yet been run.

### Dependencies

This project was created on following setup, your success to run it on other versions may vary.
* Ubuntu: 24.04
* Vagrant: 2.4.3
* VirtualBox 7.1.4

## Acknowledgments
* [vancanhuits vagrant-k8s](https://github.com/vancanhuit/vagrant-k8s)