
# zpx
### How to run the scripts
Give the relevant permissions to the shell script files
```sh
chmod +x ./scripts/*.sh
```

### Modify the variables
Open the ```./scripts/variables.sh``` file and modify the following params if required:
```sh
export ZONE=us-west1-b
export CLUSTER_NAME=testpxsetup2
export CLUSTER_NUM_NODES=2
export CLUSTER_INSTANCE_TYPE=e2-standard-4
export PX_DOMAIN=pxtest2.getanton.com
```

### How to run the scripts
Give the relevant permissions to the shell script files
```sh
./scripts/setup.sh
```
