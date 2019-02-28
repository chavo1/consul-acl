## This repo contains a sample of Consul cluster with ACL. 
### It will spin up 3 Vagrant machines with 2 Consul servers - 1 Consul client in dc1 over HTTP and HTTPS.

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
#### For HTTP Consul UI is available on the following addresses:
- Servers: http://192.168.56.51:8500 etc.
- Clients: http://192.168.56.61:8500 etc.
- NGINX: http://192.168.56.61 etc.

#### For HTTPS Consul UI is available on the following addresses:
- Servers: https://192.168.56.51:8501 etc.
- Clients: https://192.168.56.61:8501 etc.

### ACL Tokens 
-  Tokens are used to determine if the caller is authorized to perform an action. More could be found [HERE](https://www.consul.io/docs/agent/acl-system.html#acl-tokens)
- The tokens will be generated in "policy/" directory

#### To Access the UI 
- Since this is for learning you can use master token from "policy/" directory to access UI. More about ACL rules could be found [HERE](https://www.consul.io/docs/agent/acl-rules.html)

#### Make a snapshot - you need a snapshot token from policy directory
```
consul snapshot save -token "< snapshot token from /vagrant/policy/snapshot-token.txt >" backup.snap
- Over HTTPS
consul snapshot save -token "< snapshot token from /vagrant/policy/snapshot-token.txt >" -ca-file=/etc/consul.d/ssl/consul-agent-ca.pem -http-addr https://127.0.0.1:8501 backup.snap
```
#### Examples of policy creation could be found in "policy/example_policy.txt"