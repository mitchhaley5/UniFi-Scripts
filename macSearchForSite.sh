#!/bin/bash
# -----------------------------------------------------------------------------
# Author: Mitchell Haley
# Created: 2025-08-28
# Description: This script is designed to help locate the site a UniFi device is located in.
#              It will prompt the user for the device's MAC address and returns the site name that the
#              device is located in.
# Usage: curl -s https://raw.githubusercontent.com/mitchhaley5/UniFi-Scripts/refs/heads/main/macSearchForSite.sh -o "$TMP" && bash "$TMP" && rm -f "$TMP"
# -----------------------------------------------------------------------------



read -p "Device MAC Address: " mac

# Normalize MAC address
mac=${mac,,}
mac=$(echo "$mac" | sed 's/[^0-9a-f]//g')

# Ensure MAC is valid (Contains exactly 12 hexadecimal characters)
if [[ ! "$mac" =~ ^[0-9a-f]{12}$ ]]; then
  echo "Invalid MAC address format ($mac). Please enter 12 hexadecimal characters."
  exit 1
fi

# Add colons back in to the MAC address. The database stores MAC addresses with colons and the query will not return any results if colons are missing.
mac=$(echo "$mac" | sed 's/../&:/g; s/:$//')

# Query MongoDB for device with matching MAC and extract the id for the site the device is located on and the device name
device_output=$(mongosh --port 27117 ace --eval "JSON.stringify(db.device.find({\"mac\": \"$mac\"}).toArray())")
device_site_id=$(echo "$device_output" | jq -r '.[0].site_id')
device_name=$(echo "$device_output" | jq -r '.[0].name')

# Devices must have a site_id. If they do not, then a device was not found.
if [[ -z "$device_site_id" || "$device_site_id" == "null" ]]; then
  echo "Could not find a device with a MAC address of: $mac in this controller"
  exit 1
fi

# Find the site name associated with the device
site_output=$(mongosh --port 27117 ace --eval "JSON.stringify(db.site.findOne({\"_id\": ObjectId(\"$device_site_id\")}))")
site_name=$(echo "$site_output" | jq -r '.desc')

# Ensure the site name was pulled correctly
if [[ -z "$site_name" || "$site_name" == "null" ]]; then
  echo "The site with ID: $device_site_id has no name"
  exit 1
fi

echo "The device $mac ($device_name) is located on the site: $site_name"
