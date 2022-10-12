#!/bin/bash

# CREATE: Basic Script to create Seed Archive Files from Conjur Leader (Master) for Follower Servers

# Global Variables
containerName="conjur-leader"
followerDNS="conjur-follower-eu.demo.cybr"
username="ec2-user"
replicationSetName="eu"
leaderPemFile="bnl-keypair.pem"
seedsDir="/opt/cyberark/dap/seeds"

# Create Seed Archive File
echo "Create seed archive files"
echo "------------------------------------"
set -x
podman exec $containerName bash -c "evoke seed follower --replication-set $replicationSetName $followerDNS > $seedsDir/follower-$replicationSetName.tar"
scp -i $leaderPemFile /opt/cyberark/dap/seeds/follower-$replicationSetName.tar $username@$followerDNS:$seedsDir
set +x