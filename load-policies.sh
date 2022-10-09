#!/bin/bash

set -a
source ".env"
set +a

conjur policy load -b root -f app.yaml
conjur policy load -b root -f permit-us-replication.yaml
conjur policy load -b root -f permit-eu-replication.yaml