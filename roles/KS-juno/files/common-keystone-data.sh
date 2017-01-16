#! /bin/bash

###### Inject Sample Data ######
CONTROLLER_PUBLIC_ADDRESS=${CONTROLLER_PUBLIC_ADDRESS:-localhost}
CONTROLLER_ADMIN_ADDRESS=${CONTROLLER_ADMIN_ADDRESS:-localhost}
CONTROLLER_INTERNAL_ADDRESS=${CONTROLLER_INTERNAL_ADDRESS:-localhost}

#TOOLS_DIR=$(cd $(dirname "$0") && pwd)
export SERVICE_TOKEN=ADMIN
CONFIG_ADMIN_PORT=35357
CONFIG_PUBLIC_PORT=5000
export SERVICE_ENDPOINT=http://localhost:35357/v2.0

function get_id () {
    echo `"$@" | grep ' id ' | awk '{print $4}'`
}

echo "===================================ENV VAR============================"
#
# Default Service tenant
#
SERVICE_TENANT=$(get_id keystone tenant-create --name=service \
                                               --description "Service Tenant")

ADMIN_USER=$(get_id keystone user-create --name=admin \
                                         --pass=password)

ADMIN_ROLE=$(get_id keystone role-create --name=admin)

keystone user-role-add --user-id $ADMIN_USER \
                       --role-id $ADMIN_ROLE \
                       --tenant-id $SERVICE_TENANT

SWIFT_USER=$(get_id keystone user-create --name=swift \
                                         --pass=password \
                                         --tenant-id $SERVICE_TENANT)

keystone user-role-add --user-id $SWIFT_USER \
                       --role-id $ADMIN_ROLE \
                       --tenant-id $SERVICE_TENANT

#
# Keystone service
#
KEYSTONE_SERVICE=$(get_id \
keystone service-create --name=keystone \
                        --type=identity \
                        --description="Keystone Identity Service")

keystone endpoint-create --region RegionOne --service-id $KEYSTONE_SERVICE \
        --publicurl "http://$CONTROLLER_PUBLIC_ADDRESS:$CONFIG_PUBLIC_PORT/v2.0" \
        --adminurl "http://$CONTROLLER_ADMIN_ADDRESS:$CONFIG_ADMIN_PORT/v2.0" \
        --internalurl "http://$CONTROLLER_INTERNAL_ADDRESS:$CONFIG_PUBLIC_PORT/v2.0"

