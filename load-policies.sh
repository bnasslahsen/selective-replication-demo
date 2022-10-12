#!/bin/bash


conjur policy load -b root -f permit-us-replication.yaml
conjur policy load -b root -f permit-eu-replication.yaml

conjur variable set -i eu-only-1 -v "eu-test1"
conjur variable set -i eu-only-2 -v "eu-test2"
conjur variable set -i us-only -v "us-test"
conjur variable set -i full-only -v "ful-test"