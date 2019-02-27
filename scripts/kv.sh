#!/usr/bin/env bash
set -x
TLS_ENABLE=${TLS_ENABLE}
HOST=$(hostname)
export CONSUL_TOKEN=`cat /vagrant/policy/master-token.txt | grep "SecretID:" | cut -c15-` # bootstrap token

if [ "$TLS_ENABLE" = true ] ; then
    HTTP=https://127.0.0.1:8501/v1/kv/$HOST/nginx
    f='-k'
else
    HTTP=http://127.0.0.1:8500/v1/kv/$HOST/nginx
    f=''
fi

# API add value
curl -s -H "x-consul-token: $CONSUL_TOKEN" "$f" \
    --request PUT \
    --data '<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx from '$HOST'!</h1>
</body>
</html>' \
    "$HTTP"

set +x