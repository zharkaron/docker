#!/bin/bash

CLIENT_NAME=$1
if [ -z "$CLIENT_NAME"]; then
	echo "Usage: $0 <client-name>"
	exit 1
fi

cat <<EOF > $1.ovpn

client
remote your_server_ip 1194
proto udp
resolv-retry infinite
nobind
persist-key
persist-tun
dev tun
ca ca.crt
cert $1.crt
key $1.crt
cipher AES-256-CBC
auth SHA256
tls-auth ta.key 1

EOF

cd /etc/openvpn/easy-rsa
./easyrsa gen-req $CLIENT_NAME nopass
./easyrsa sign-req client $CLIENT_NAME

cp pki/issued/$CLIENT_NAME.crt client-keys
cp pki/private/$CLIENT_NAME.key client-keys
cp ta.key client-keys
cp pki/ca.crt client-keys

echo "Client configuration and keys generated for $CLIENT_NAME."
