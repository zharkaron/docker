# Use a lightweight Linux distribution as the base image
FROM debian:bullseye-slim

# Install OpenVPN and necessary tools
RUN apt-get update && \
    apt-get install -y openvpn easy-rsa && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /etc/openvpn

# Copy OpenVPN configuration files (if available)
COPY ./config /etc/openvpn

# Expose the OpenVPN default port (UDP 1194)
EXPOSE 1194/udp

# Start OpenVPN server
CMD ["openvpn", "--config", "/etc/openvpn/server.conf"]
