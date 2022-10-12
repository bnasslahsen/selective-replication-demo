#!/bin/bash

# CREATE:conjur master instance

# Global Variables
containerName="conjur-leader"
CONJUR_IMAGE=conjur-appliance:5.16.13.dev.1
masterDNS="conjur-leader.demo.cybr"
conjurAccount=deutsche-telekom

# Create conjur master
echo "Creating conjur master"
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
    --publish "5432:5432" \
    --publish "1999:1999" \
    --log-driver journald \
    --volume /opt/cyberark/dap/config:/etc/conjur/config:Z \
    --volume /opt/cyberark/dap/security:/opt/cyberark/dap/security:Z \
    --volume /opt/cyberark/dap/backups:/opt/conjur/backup:Z \
    --volume /opt/cyberark/dap/seeds:/opt/cyberark/dap/seeds:Z \
    --volume /opt/cyberark/dap/logs:/var/log/conjur:Z \
    $CONJUR_IMAGE

sleep 10

podman exec $containerName evoke configure master \
  --accept-eula \
  --hostname $masterDNS \
  --master-altnames $(hostname -s),$(hostname -f) \
  --admin-password="$(cat admin_password)" \
  $conjurAccount

set +x