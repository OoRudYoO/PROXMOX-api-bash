#!/bin/bash

PROXMOX_NODE_IP=ip-here

API_USER=username
API_USER_PASSWORD=password

CRED="username=$API_USER@pve&password=$APT_USER_PASSWORD"

curl --silent --insecure --data $CRED https://$PROXMOX_NODE_IP:8006/api2/json/access/ticket | jq --raw-output '.data.ticket' | sed 's/^/PVEAuthCookie=/' > cookie
curl --silent --insecure --data $CRED https://$PROXMOX_NODE_IP:8006/api2/json/access/ticket | jq --raw-output '.data.CSRFPreventionToken' | sed 's/^/CSRFPreventionToken:/' > csrftoken