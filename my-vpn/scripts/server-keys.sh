#!/bin/bash

PACKAGE_1="openvpn"
PACKAGE_2="easy-rsa"

check_and_install_package(){
	local package=$1
	if dpkg -l | grep -q "$package"; then
		echo "$package is already installed."
	else
		echo "$package is not installed. installing now ..."
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
ca="build-ca"
crt="gen-req server nopass"
key="sign-req server server"
dh="gen-dh"
certificate(){
	local command=$1
	./easyrsa $command
}
certificate $ca
certificate $crt
certificate $key
certificate $dh

openvpn --genkey secret ta.key
file_path= "~/docker/my-vpn/config

cp pki/issued/server.crt $file_path
cp pki/private/server.key $file_path
cp ta.key $file_path
cp pki/ca.crt $file_path
cp dh.pem $file_path
