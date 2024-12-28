#!/bin/bash

docker build -t openvpn-server .

docker run --cap-add=NET_ADMIN -d -p 1194:1194/udp --device /dev/net/tun --name openvpn openvpn-server
