#!/bin/bash

# Global Variables
conjurURL=$(hostname -f)
conjurAccount=deutsche-telekom
conjurUser=admin
conjurPassword="$(cat admin_password)"

# Init Conjur CLI
echo "Init Conjur CLI"
echo "------------------------------------"
set -x
conjur init --s --url https://$conjurURL --account $conjurAccount << EOF
yes
yes
yes
yes
EOF

# Login to Conjur CLI
conjur login -i $conjurUser -p $conjurPassword
set +x