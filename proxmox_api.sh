#!/bin/bash

PROXMOX_NODE_IP=put-here-ip
PROXMOX_NODE_NAME=put-here-name
PROXMOX_STORAGE="put-here-storage-name"

API_USER=put-here-username
API_USER_PASSWORD=put-here-password

CRED="username=$API_USER@pve&password=$API_USER_PASSWORD"

curl --silent --insecure --data $CRED https://$PROXMOX_NODE_IP:8006/api2/json/access/ticket | jq --raw-output '.data.ticket' | sed 's/^/PVEAuthCookie=/' > cookie
curl --silent --insecure --data $CRED https://$PROXMOX_NODE_IP:8006/api2/json/access/ticket | jq --raw-output '.data.CSRFPreventionToken' | sed 's/^/CSRFPreventionToken:/' > token

# container config

CPU=1
CPUUNITS=512
MEMORY=512
DISK=4G
SWAP=0
OS_TEMPLATE="IMAGES:vztmpl/centos-8-default_20191016_amd64.tar.xz"


# script options

case $1 in

    start|stop) curl --silent --insecure  --cookie "$(<cookie)" --header "$(<token)" -X POST https://$PROXMOX_NODE_IP:8006/api2/json/nodes/$PROXMOX_NODE_NAME/lxc/$2/status/$1; echo "  done." ;;

    create) curl --insecure  --cookie "$(<cookie)" --header "$(<token)" -X POST --data-urlencode net0="name=tnet$2,bridge=vmbr0" --data ostemplate=$OS_TEMPLATE --data storage=$PROXMOX_STORAGE --data vmid=$2 --data cores=$CPU --data cpuunits=$CPUUNITS --data memory=$MEMORY --data swap=$SWAP --data hostname=ctnode$2 https://$PROXMOX_NODE_IP:8006/api2/json/nodes/$PROXMOX_NODE_NAME/lxc; echo "  done."  ;;

    delete) curl --silent --insecure  --cookie "$(<cookie)" --header "$(<token)" -X DELETE https://$PROXMOX_NODE_IP:8006/api2/json/nodes/$PROXMOX_NODE_NAME/lxc/$2;echo "  done." ;;

    *) echo ""; echo " usage:  start|stop|create|delete <vmid> ";echo ""; ;;

esac

# remove cookie and token

rm cookie token
