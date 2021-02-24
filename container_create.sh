#!/bin/bash

PROXMOX_NODE_IP=ip-here

CPU=1
CPUUNITS=512
MEMORY=512
DISK=4G
SWAP=0

SLEEP=5

for i in $(seq 710 720);do

    echo " creating container $i ...";

    curl --insecure  --cookie "$(<cookie)" --header "$(<csrftoken)" -X POST --data-urlencode net0="name=tnet$i,bridge=vmbr0" --data-urlencode ostemplate="IMAGES:vztmpl/centos-8-default_20191016_amd64.tar.xz" --data-urlencode storage="DATA" --data vmid=$i --data cores=$CPU --data cpuunits=$CPUUNITS --data memory=$MEMORY --data swap=$SWAP --data hostname=tnode$i https://$PROXMOX_NODE_IP:8006/api2/json/nodes/oldpx/lxc

    echo " wait $SLEEP s";
    sleep $SLEEP;
    echo " done ... ";

done

