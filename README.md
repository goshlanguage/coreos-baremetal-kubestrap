CoreOS-Baremetal-Kubestrap
====

This repo aims to assist anyone seeking to manage a CoreOS cluster that runs on Baremetal, and will bootstrap Kubernetes, managable via ansible on said environment.

If you are looking for a way to PXE boot servers with CoreOS so that it can be installed to bare-metal, see my PXE-Z project with aims to bootstrap a CentOS server to PXE boot other servers within your network with an interactive menu. (Note this project needs help, so contributers are welcome)

https://github.com/ryanhartje/pxe-z

Background
===
CoreOS is a popular container OS. It's minimalistic, so it doesn't come with python installed, nor is there a package manager to make python or ruby available.

Because of this, popular config management tools won't work initially. We could possibly have our cloud-config's download a binary, however I don't necessarily know of a secure way of making sure the binary downloaded is not malicious.

Further information can be found here:
https://coreos.com/blog/managing-coreos-with-ansible.html

Setup
===

If you're developing on Mac, you'll want to install xcode dev tools and ansible:

```sh
xcode-select --install
pip install --user ansible
```

Getting Started
===

To bootstrap a CoreOS cluster, we'll need:
- certs generated for the api, workers, and kubectl authentication
- a working etcd cluster
- proper manifests generated for hyperkube

First, let's generate our certs:

```sh
./gencerts.sh
```
