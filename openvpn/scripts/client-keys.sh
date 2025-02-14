#!/bin/bash

CLIENT_NAME=$1
if [ -z "$CLIENT_NAME" ]; then
        echo "Usage: $0 <client-name>"
        exit 1
fi

cat << EOF > client-keys/$CLIENT_NAME.ovpn
client
tls-client
dev tun
proto tcp
remote <Server IP Address> 443
resolv-retry infinite
redirect-gateway def1
nobind
persist-key
persist-tun
ca ca.crt
cert $CLIENT_NAME.crt
key $CLIENT_NAME.key
tls-auth ta.key 1
data-ciphers AES-256-GCM:AES-128-GCM
auth SHA256
remote-cert-tls server
verb 3
EOF

cd /etc/openvpn/easy-rsa
./easyrsa gen-req $CLIENT_NAME nopass
./easyrsa sign-req client $CLIENT_NAME

file_path="/home/raspberry/docker/openvpn/scripts/client-keys/"

cp pki/issued/$CLIENT_NAME.crt $file_path
cp pki/private/$CLIENT_NAME.key $file_path
cp ta.key $file_path
cp pki/ca.crt $file_path

echo "Client configuration and keys generated for $CLIENT_NAME."
