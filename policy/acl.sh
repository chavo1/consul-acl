#!/usr/bin/env bash

TLS_ENABLE=${TLS_ENABLE}

# Install sshpass -if not installed
which sshpass &>/dev/null || {
    apt-get sshpass -y 
}
set -x
HOST=$(hostname)
# - Create the consul directory
mkdir -p /etc/consul.d/
# - Enable ACLs on all the servers. 
if [[ $HOST == consul-dc1-server01 ]]; then
sudo cat <<EOF > /etc/consul.d/acl.json
{
  "acl": {
    "enabled": true,
    "default_policy": "deny",
    "down_policy": "extend-cache"
  }
}
EOF
systemctl restart consul
sleep 10
# - Create the initial bootstrap token. 

  if [[ "$TLS_ENABLE" = true ]] ; then
    TLS='-ca-file=/etc/consul.d/ssl/consul-agent-ca.pem -http-addr https://127.0.0.1:8501'
  else
    TLS=''
  fi
    consul acl bootstrap $TLS > /vagrant/policy/master-token.txt
    TOKEN=`cat /vagrant/policy/master-token.txt | grep "SecretID:" | cut -c15-` # bootstrap token
    export CONSUL_HTTP_TOKEN=$TOKEN

    # - Create agent policy
    consul acl policy create $TLS -name "agent-token" \
    -description "Agent Token Policy" \
    -rules 'node_prefix "" { policy = "write" } service_prefix "" { policy = "write" }'
    # - Create agent token
    consul acl token create $TLS -description "Agent Token" -policy-name "agent-token" > /vagrant/policy/agent-token.txt

    # - Create snapshot policy
    consul acl policy create $TLS -name "snapshot-token" \
    -description "Snapshot Token Policy" \
    -rules 'acl = "write"'
    # - Create snapshot token
    consul acl token create $TLS -description "Snapshot Token" -policy-name "snapshot-token" > /vagrant/policy/snapshot-token.txt

    # - Apply the new token to the servers. // change the token in file
    AGENT_TOKEN=`cat /vagrant/policy/agent-token.txt | grep "SecretID:" | cut -c15-` # bootstrap token
    export AGENT_TOKEN=$AGENT_TOKEN

sudo cat <<EOF > /etc/consul.d/acl.json
{
  "acl": {
    "enabled": true,
    "default_policy": "deny",
    "down_policy": "extend-cache",
    "tokens": {
      "default": "${AGENT_TOKEN}"
    }
  }
}
EOF

systemctl restart consul

else

sshpass -p 'vagrant' scp -o StrictHostKeyChecking=no vagrant@192.168.56.51:"/etc/consul.d/acl.json" /etc/consul.d/
systemctl restart consul
sleep 10

fi

set +x