#!/usr/bin/env bash

SWIFT_PUBLIC_ENDPOINT=$1
SWIFT_INTERNAL_ENDPOINT=$2
SWIFT_ADMIN_ENDPOINT=$3
SWIFT_ENDPOINT_SCHEME=${4:-http}

function get_id () {
    echo `"$@" | grep ' id ' | awk '{print $4}'`
}

###### Inject v2 Data ######
export SERVICE_TOKEN=ADMIN
export SERVICE_ENDPOINT=http://localhost:35357/v2.0

#
# Swift service
#
SWIFT_SERVICE=$(get_id \
keystone service-create --name=swift \
                        --type="object-store" \
                        --description="Swift Service")

if [[ -z "$DISABLE_ENDPOINTS" ]]; then
    keystone endpoint-create --region RegionOne --service-id $SWIFT_SERVICE \
        --publicurl   "$SWIFT_ENDPOINT_SCHEME://$SWIFT_PUBLIC_ENDPOINT/v1/KEY_\$(tenant_id)s" \
        --adminurl    "$SWIFT_ENDPOINT_SCHEME://$SWIFT_ADMIN_ENDPOINT/v1" \
        --internalurl "$SWIFT_ENDPOINT_SCHEME://$SWIFT_INTERNAL_ENDPOINT/v1/KEY_\$(tenant_id)s"
fi

echo "==================Sample data Inject Finished=========================="
echo
sleep 2
echo
echo "==================Create User/Password/Tenant : swiftstack/password/SS===================="

SS_TENANT=$(get_id \
keystone tenant-create --name SS --enabled true --description "SwiftStack-DEV Tenant")
keystone user-create --name swiftstack --pass password --tenant-id $SS_TENANT --email support@swiftstack.com --enabled true

#echo
#echo "================= Test v2.0 API to get TOKEN/Service Catalog of user swiftstack =================="
#sleep 2

#curl -d '{"auth":{"passwordCredentials":{"username": "swiftstack", "password": "password"},"tenantName":"SS"}}' -H "Content-type: application/json" http://localhost:5000/v2.0/tokens | python -mjson.tool

#sleep 2
#echo
#echo "================== Test Keystone V3 API to get TOKEN/Service Catalog of user swiftstack ====================="

#curl -d '{"auth":{"identity":{"methods":["password"],"password":{"user":{"domain":{"name":"default"},"name":"swiftstack","password":"password"}}},"scope":{"project":{"domain":{"name":"default"},"name":"SS"}}}}' -H "Content-type: application/json" http://localhost:5000/v3/auth/tokens | python -mjson.tool
