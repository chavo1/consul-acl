## This repo contains a sample of Consul cluster with ACL. 
### It will spin up 3 Vagrant machines with 2 Consul servers - 1 Consul client in dc1 over HTTP.

#### The usage is pretty simple
- Vagrant should be [installed](https://www.vagrantup.com/)
### Usage
- Clone the repo
```
git clone https://github.com/chavo1/consul-acl.git
cd consul-acl
```
- Start the lab
```
vagrant up
```
#### Check if Consul UI is available on the following addresses:
- Servers: http://192.168.56.51:8500 etc.
- Clients: http://192.168.56.61:8500 etc.
- NGINX: http://192.168.56.61 etc.

#### Make a snapshot - you need a snapshot token from policy directory
```
consul snapshot save -token "< snapshot token from /vagrant/policy/snapshot-token.txt >" backup.snap
```
#### Examples of policy creation could be found in "policy/example_policy.txt"