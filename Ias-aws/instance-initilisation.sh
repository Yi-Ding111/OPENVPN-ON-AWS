#!/bin/bash

# Define variables for configuration settings
ADMIN_INTERFACE="0.0.0.0"
CA_TYPE="secp384r1"
WEB_CERT_TYPE="secp384r1"
ADMIN_PORT="943"
VPN_PORT="443"
ROUTE_CLIENT_TRAFFIC="yes"
ROUTE_DNS_TRAFFIC="no"
ACCESS_PRIVATE_SUBNETS="yes"
OPENVPN_USERNAME="openvpn"
OPENVPN_PASSWORD="YourStrongPassword" # Replace with your desired password

# Update the system
sudo apt update && sudo apt upgrade -y

# Install OpenVPN Access Server
# Assuming wget and gdebi are already installed
wget [URL to OpenVPN Access Server package]
sudo gdebi [OpenVPN package name]

# Use 'expect' to handle interactive prompts
expect <<END
  spawn /usr/local/openvpn_as/bin/ovpn-init
  expect "Agree? \\\[no\\\]:"
  send "yes\r"
  expect "Primary Access Server node? \\\[yes\\\]:"
  send "\r"
  expect "Specify the network interface"
  send "\r"
  expect "What public/private type/algorithms for OpenVPN CA?"
  send "\r"
  expect "What public/private type/algorithms for the self-signed web certificate?"
  send "\r"
  expect "Specify the port number for the Admin Web UI."
  send "\r"
  expect "Specify the TCP port number for the OpenVPN Daemon"
  send "\r"
  expect "Should client traffic be routed by default through the VPN?"
  send "$ROUTE_CLIENT_TRAFFIC\r"
  expect "Should client DNS traffic be routed by default through the VPN?"
  send "$ROUTE_DNS_TRAFFIC\r"
  expect "Private subnets detected:"
  send "$ACCESS_PRIVATE_SUBNETS\r"
  expect "login to the Admin UI as 'openvpn'?"
  send "\r"
  expect "Type a password for the 'openvpn' account:"
  send "$OPENVPN_PASSWORD\r"
  expect "Confirm the password for the 'openvpn' account:"
  send "$OPENVPN_PASSWORD\r"
  expect "Please specify your Activation key (or leave blank to specify later):"
  send "\r"
  expect eof
END

# Additional configurations and setups can go here

echo "OpenVPN Access Server setup is complete."
