#!/bin/bash

# Install: Basic Script to install Follower

# Global Variables
containerName="conjur-follower-eu"
replicationSetName="eu"
seedsDir="/opt/cyberark/dap/seeds"

# Install follower
echo "Install follower"
echo "------------------------------------"
set -x
podman exec $containerName evoke unpack seed $seedsDir/follower-$replicationSetName.tar
podman exec $containerName evoke configure follower
curl -k https://$(hostname -f)/health
set +x