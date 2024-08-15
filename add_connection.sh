#!/bin/bash

# Variables
SSID="eduroam"
CONNECTION_NAME="eduroam"

# Prompt for username
read -p "Enter your username: " USERNAME

# Prompt for password (input will be hidden)
read -sp "Enter your password: " PASSWORD
echo

# Check if nmcli is installed
if ! command -v nmcli &> /dev/null; then
    echo "nmcli could not be found, please install NetworkManager"
    exit 1
fi

# Get the first Wi-Fi interface
IFNAME=$(nmcli device status | awk '$2 == "wifi" {print $1; exit}')

# Check if the connection with the same name exists
if nmcli connection show "$CONNECTION_NAME" &> /dev/null; then
    echo "Connection $CONNECTION_NAME already exists, removing it."
    nmcli connection delete "$CONNECTION_NAME"
fi

# Add the 802.1X Wi-Fi connection with PEAP/MSCHAPv2 authentication
nmcli connection add type wifi \
    con-name "$CONNECTION_NAME" \
    ifname "$IFNAME" \
    ssid "$SSID" \
    wifi-sec.key-mgmt wpa-eap \
    802-1x.eap peap \
    802-1x.identity "$USERNAME" \
    802-1x.phase1-auth-flags "0x20" \
    802-1x.phase2-auth mschapv2 \
    802-1x.password "$PASSWORD"

# Optionally, bring the connection up
nmcli connection up "$CONNECTION_NAME"

# Verify the connection
if nmcli connection show "$CONNECTION_NAME" &> /dev/null; then
    echo "Connection $CONNECTION_NAME has been successfully added and activated."
else
    echo "Failed to add or activate the connection $CONNECTION_NAME."
    exit 1
fi
