#! /bin/bash

swift_host=$1
echo "====swift_host===="
echo $swift_host

export OS_USERNAME=admin
export OS_PASSWORD=ADMIN
export OS_PROJECT_NAME=admin
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_DOMAIN_NAME=Default
export OS_AUTH_URL=http://localhost:35357/v3
export OS_IDENTITY_API_VERSION=3
source ~/source_file/user-admin.source

echo "====Source ENV VAR===="
#
# Domain: default
# Project=Tenant: swift
# User: swift
# Role: usr
#

echo "====Create Swift Relative Data===="
openstack domain create --description "An Default Domain" default
openstack project create --domain default --description "Swift Service Project" swift
openstack user create --domain default --password swift swift
openstack role create swiftoperator
openstack role add --project swift --user swift swiftoperator
openstack role create ResellerAdmin
openstack role add --project swift --user swift ResellerAdmin
openstack role add --project swift --user swift admin
openstack role add --project swift --user swift _member_

echo "====Test to get Token===="
openstack --os-auth-url http://localhost:35357/v3 --os-project-domain-name default --os-user-domain-name default --os-project-name swift --os-username swift --os-password swift token issue
openstack --os-auth-url http://localhost:35357/v3 --os-project-domain-name default --os-user-domain-name default --os-project-name admin --os-username admin --os-password ADMIN  token issue

echo "====Create Swift Service===="
openstack service create --name swift --description object-store object-store

echo "====Create Swift Endpoint in Keystone===="
openstack endpoint create --region RegionOne swift admin "http://$swift_host/v1"
openstack endpoint create --region RegionOne swift internal "http://$swift_host/v1/KEY_\$(tenant_id)s"
openstack endpoint create --region RegionOne swift public "http://$swift_host/v1/KEY_\$(tenant_id)s"
