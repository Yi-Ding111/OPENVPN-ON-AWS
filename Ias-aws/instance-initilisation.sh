#!/bin/bash

set -e

# Check if expect is installed and install it if not
# if ! command -v expect &> /dev/null; then
#     echo "expect could not be found, attempting to install it..."

#     # Detect the package manager and install expect
#     if command -v apt-get &> /dev/null; then
#         sudo apt-get update && sudo apt-get install -y expect
#     elif command -v yum &> /dev/null; then
#         sudo yum install -y expect
#     elif command -v brew &> /dev/null; then
#         brew install expect
#     else
#         echo "No compatible package manager found. Please install expect manually."
#         exit 1
#     fi

#     echo "expect has been installed."
# fi

# Define variables for configuration settings
echo "Defining configuration settings..."

USER="openvpnas"
EIP_ADDRESS=$FORMATTED_EIP_ADDRESS
ADMIN_PORT="943"
VPN_PORT="443"
OPENVPN_USERNAME="openvpn"
OPENVPN_PASSWORD="Dingyi1224!" # Replace with your desired password

echo "Setting permissions for openvpn.pem..."

chmod 400 "/home/runner/work/OPENVPN-ON-AWS/OPENVPN-ON-AWS/openvpn.pem"

# Begin the configuration of OpenVPN Access Server
echo "Configuring OpenVPN Access Server..."

# Use expect to handle the entire SSH and configuration process
/usr/bin/expect <<EOF
set timeout 30

spawn ssh -i "/home/runner/work/OPENVPN-ON-AWS/OPENVPN-ON-AWS/openvpn.pem" $USER@ec2-$FORMATTED_EIP_ADDRESS.ap-southeast-1.compute.amazonaws.com

# Initial SSH connection and authenticity check
expect {
    -re {Are you sure you want to continue connecting.*} {
        send "yes\r"
        exp_continue
    }
    -re {Please enter 'yes' to indicate your agreement \\[no\\]:} {
        send "yes\r"
        exp_continue
    }
    -re {Will this be the primary Access Server node.*} {
        send "\r"  ;# Press ENTER for default [yes]
        exp_continue
    }
    -re {Please enter the option number from the list above.*} {
        send "\r"
        exp_continue
    }
    -re {What public/private type/algorithms do you want to use for the OpenVPN CA.*} {
        send "\r"
        exp_continue
    }
    -re {What public/private type/algorithms do you want to use for the self-signed web certificate.*} {
        send "\r"
        exp_continue
    }
    -re {Please specify the port number for the Admin Web UI} {
        send "$ADMIN_PORT\r"
        exp_continue
    }
    -re {Please specify the TCP port number for the OpenVPN Daemon} {
        send "$VPN_PORT\r"
        exp_continue
    }
    -re {Should client traffic be routed by default through the VPN.*} {
        send "yes\r"
        exp_continue
    }
    -re {Should client DNS traffic be routed by default through the VPN.*} {
        send "\r"
        exp_continue
    }
    -re {Should private subnets be accessible to clients by default.*} {
        send "\r"
        exp_continue
    }
    -re {Do you wish to login to the Admin UI as "openvpn".*} {
        send "\r"
        exp_continue
    }
    -re {Type a password for the 'openvpn' account.*} {
        send "$OPENVPN_PASSWORD\r"
        exp_continue
    }
    -re {Confirm the password for the 'openvpn' account.*} {
        send "$OPENVPN_PASSWORD\r"
        exp_continue
    }
    -re {Please specify your Activation key.*} {
        send "\r"
    }
    timeout {
        send_user "Connection timed out\n"
        exit 1
    }
    eof {
        send_user "SSH connection failed or was interrupted\n"
        exit 1
    }
}

expect eof
EOF

echo "OpenVPN Access Server setup is complete."

