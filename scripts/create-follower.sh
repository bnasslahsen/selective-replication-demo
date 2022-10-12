#!/bin/bash

# CREATE:Follower instance

# Global Variables
containerName="conjur-follower-full"
CONJUR_IMAGE=conjur-appliance:5.16.13.dev.1

# Create conjur follower
echo "Creating conjur follower"
echo "------------------------------------"
set -x
podman rm --ignore --force $containerName
podman run \
    --name $containerName \
    --detach \
    --restart=unless-stopped \
    --security-opt seccomp=/opt/cyberark/dap/security/seccomp.json \
    --publish "443:443" \
    --publish "444:444" \
    --log-driver journald \
    --volume /opt/cyberark/dap/config:/etc/conjur/config:Z \
    --volume /opt/cyberark/dap/security:/opt/cyberark/dap/security:Z \
    --volume /opt/cyberark/dap/backups:/opt/conjur/backup:Z \
    --volume /opt/cyberark/dap/seeds:/opt/cyberark/dap/seeds:Z \
    --volume /opt/cyberark/dap/logs:/var/log/conjur:Z \
    $CONJUR_IMAGE

set +x