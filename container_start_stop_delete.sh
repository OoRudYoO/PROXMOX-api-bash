#!/bin/bash

PROXMOX_NODE=ip-here
TARGETNODE=proxmox-hostname

case $1 in

    start|stop) curl --silent --insecure  --cookie "$(<cookie)" --header "$(<csrftoken)" -X POST https://$PROXMOX_NODE_IP:8006/api2/json/nodes/$TARGETNODE/lxc/$2/status/$1 ;;

    delete) curl --silent --insecure  --cookie "$(<cookie)" --header "$(<csrftoken)" -X DELETE https://$PROXMOX_NODE_IP:8006/api2/json/nodes/$TARGETNODE/lxc/$2 ;;

    *) echo ""; echo " usage:  container start|stop|delete <vmid> ";echo ""; ;;

esac