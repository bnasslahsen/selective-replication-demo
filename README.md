# Demo script for the selective replication

## How replication Sets works ?

![](replication-set.png)


## Demo Architecture

![](archi.png)

## Pre-requisites
- Minimum conjur 13.x binary uploaded to the target servers
- conjur-cli
- docker or podman installed
- Clone this git repository

## Create Conjur Master
- Go to scrips directory:
```shell
cd scripts
```
- Then run:
```shell
./create-leader.sh
```
- Check master health:
```shell
curl -k https://$(hostname -f)/health
```
- Check available replication set:
```shell
podman exec conjur-leader evoke replication-set list
```

## Load sample policy
- Go to polcies directory:
```shell
cd policies
```
- Run:
```shell
conjur policy load -b root -f app.yaml
conjur variable set -i full-only -v "full-test"
conjur variable set -i eu-only -v "eu-test"
conjur variable set -i us-only -v "us-test"
conjur variable set -i Vault/LOB_user/Safe01/delegation/eu-only-1 -v "eu-test1"
conjur variable set -i Vault/LOB_user/Safe01/delegation/eu-only-2 -v "eu-test2"
```

## Create the followers replication Sets
- Run:
```shell
podman exec conjur-leader evoke replication-set create us
podman exec conjur-leader evoke replication-set create eu
```
- Check available replication set:
```shell
podman exec conjur-leader evoke replication-set list
```

## Add secrets to replication Sets
- Create the US policy replication Set:
```shell
conjur policy load -b root -f permit-us-replication.yaml
```

- List resources that would replicate the data for us region:

```shell
podman exec conjur-leader bash -c $'
chpst -u conjur psql -c "
SELECT resource_id
FROM resources
WHERE is_role_allowed_to(
\'system:group:conjur/replication-sets/us/replicated-data\',
\'read\',
resource_id
);"
'
```

- Create the EU policy replication Set:
```shell
conjur policy load -b root -f permit-eu-replication.yaml
```

- List resources that would replicate the data for eu region:

```shell
podman exec conjur-leader bash -c $'
chpst -u conjur psql -c "
SELECT resource_id
FROM resources
WHERE is_role_allowed_to(
\'system:group:conjur/replication-sets/eu/replicated-data\',
\'read\',
resource_id
);"
'
```

## Generate the seed files for each follower
- Go to scrips directory:
```shell
cd scripts
```
- Run in the leader:
```shell
./create-follower-seed-full.sh
./create-follower-seed-us.sh
./create-follower-seed-eu.sh
```

## Deploy the followers
- Run in each follower node:
```shell
./create-follower.sh
./install-follower.sh
```

## Check the replicated secrets 
- Run in FULL follower node:
```shell
./init-conjur-cli.sh
conjur list --kind variable
conjur variable get -i full-only
conjur variable get -i eu-only
conjur variable get -i us-only
conjur variable get -i Vault/LOB_user/Safe01/delegation/eu-only-1
conjur variable get -i Vault/LOB_user/Safe01/delegation/eu-only-2
```

- Run in US follower node:
```shell
./init-conjur-cli.sh
conjur list --kind variable
conjur variable get -i us-only
conjur variable get -i full-only
conjur variable get -i eu-only
conjur variable get -i Vault/LOB_user/Safe01/delegation/eu-only-1
conjur variable get -i Vault/LOB_user/Safe01/delegation/eu-only-2
```

- Run in EU follower node:
```shell
./init-conjur-cli.sh
conjur list --kind variable
conjur variable get -i eu-only
conjur variable get -i Vault/LOB_user/Safe01/delegation/eu-only-1
conjur variable get -i Vault/LOB_user/Safe01/delegation/eu-only-2
conjur variable get -i us-only
conjur variable get -i full-only
```
