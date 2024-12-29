#!/bin/bash

PACKAGE_1="openvpn"
PACKAGE_2="easy-rsa"

check_and_install_package(){
	local package=$1
	if dpkg -l | grep -q "$package"; then
		echo "$package is already installed."
	else
		echo "$package is not installed. Installing now ..."
		apt-get update
		apt-get install -y $package
		echo "$package installation complete."
	fi
}

check_and_install_package $PACKAGE_1
check_and_install_package $PACKAGE_2

mkdir -p /etc/openvpn/easy-rsa
cp -r /usr/share/easy-rsa/* /etc/openvpn/easy-rsa
cd /etc/openvpn/easy-rsa

# Initialize PKI and generate keys
./easyrsa init-pki
./easyrsa build-ca
./easyrsa gen-req server nopass
./easyrsa sign-req server server
./easyrsa gen-dh

# Generate TLS authentication key
openvpn --genkey secret ta.key

# Ensure the target directory exists
file_path="/home/raspberry/docker/my-vpn/config"
# Copy files to the target directory
cp /etc/openvpn/easy-rsa/pki/issued/server.crt $file_path
cp /etc/openvpn/easy-rsa/pki/private/server.key $file_path
cp /etc/openvpn/easy-rsa/ta.key $file_path
cp /etc/openvpn/easy-rsa/pki/ca.crt $file_path
cp /etc/openvpn/easy-rsa/pki/dh.pem $file_path

echo "All keys and certificates have been generated and copied to $file_path."
