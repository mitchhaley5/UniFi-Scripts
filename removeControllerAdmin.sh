#!/bin/bash
# -----------------------------------------------------------------------------
# Author: Mitchell Haley
# Created: 2025-08-28
# Description: This script is designed to help remove admins from the unifi controller across all sites on a controller
# Usage: TMP=$(mktemp) && curl -s https://raw.githubusercontent.com/mitchhaley5/UniFi-Scripts/refs/heads/main/removeControllerAdmin.sh -o "$TMP" && bash "$TMP" && rm -f "$TMP"
# -----------------------------------------------------------------------------

echo "WARNING! This script will remove an admin from the entire UniFi controller. This could result in being locked out of the controller."
read -p "Email of Admin to Remove: " admin_email




# Query MongoDB by email for the admins ID
admin_info=$(mongosh --quiet --port 27117 ace --eval "JSON.stringify(db.admin.findOne({\"email\":\"$admin_email\"}))")
admin_id=$(echo "$admin_info" | jq -r '._id')

# If the admin ID is not present then there is no admin under that email address
if [[ -z "$admin_id" || "$admin_id" == "null" ]]; then
        echo "An admin with with the email address: $admin_email could not be found"
        exit 1
fi

echo "An admin with the email addres: $admin_email was found"
read -p "Are you sure you want to remove this admin from the controller? y/N: " is_removing

# Unless the answer to removing the admin is yes, cancel the script
if [[ ! "$is_removing" =~ ^[Yy]$ ]]; then
  echo "Exiting... The Admin will not be deleted."
  exit 0
fi

# Remove the admin and store the output of the acknowledgement
results=$(mongosh --port 27117 ace --eval "JSON.stringify(db.admin.deleteOne({\"_id\":ObjectId(\"$admin_id\")}))")
is_removed=$(echo "$results" | jq -r '.acknowledged')

# Notify the user if the admin was not deleted
if [[ -z "$is_removed" || "$is_removed" == "null" || "$is_removed" == "false" ]]; then
        echo "Something went wrong when removing the admin: $admin_email. Please try again"
        exit 1
fi

echo "The admin: $admin_email was removed successfully!"
