package=("openvpn" "easyrsa")
check_package() {
  if dpkg -l | grep -w"$package"; then
    apt-get install '$package' -y
  else
    mkdir -p /etc/openvpn/easy-rsa
    cp -r /usr/share/easy-rsa/* /etc/openvpn/easy-rsa
    cd /etc/openvpn/easy-rsa
    ./easyrsa init-pki
    .easyrsa build-ca
    ./easyrsa gen-req server nopass
    ./easyrsa sign-req server server
    ./easyrsa gen-dh
    openvpn --genkey secret ta.key
    cp ta.key ~/docker/my-vpn/config/
    cp pki/ca.crt ~/docker/my-vpn/config/
    cp pki/issued/server.crt ~/docker/my-vpn/config
    cp dh.pem ~/docker/vpn/config
}

for package in "$packages[0]}"; do
  check_package "$package"
done
