#!/bin/bash

CLIENT_NAME=$1
if [ -z "$CLIENT_NAME"]; then
	echo "Usage: $0 <client-name>"
	exit 1
fi

cat <<EOF > $1.ovpn

client
tls-client
dev tun
prot udp
remote <Server IP Address> 1194
resolv-retry infinite
no bind
persist-key
persist-tun
ca ca.crt
cert example.crt
key client1.key
tls-auth ta.key 1
cipher AES-256-GCM
remote-cert-tls server
verb 3

EOF

cd /etc/openvpn/easy-rsa
./easyrsa gen-req $CLIENT_NAME nopass
./easyrsa sign-req client $CLIENT_NAME

cp pki/issued/$CLIENT_NAME.crt client-keys
cp pki/private/$CLIENT_NAME.key client-keys
cp ta.key client-keys
cp pki/ca.crt client-keys

echo "Client configuration and keys generated for $CLIENT_NAME."
