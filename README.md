# ansible-keystone
To deploy OpenStack Keystone server with Ansible

* The keystone package installed from Ubuntu Cloud Archive
* This playbook supports Ubuntu x64 only. 
* J to M supports Ubuntu Trusty 14.04. 
* (not ready yet)Newton requires Ubuntu 16.04 Xenial. https://wiki.ubuntu.com/OpenStack/CloudArchive

### How to use it

1. Specify the release version of openstack in main.yaml by the role. 
    * [ KS-juno | KS-kilo | KS-liberty | KS-mitaka]

2. Edit the inventory in hosts. 
3. Edit the Swift endpoint in `roles/v2-data/vars/main.yaml`.
4. Sync the SSH-key to target host's swiftstack user. 
5. Run the playbook `$ansible-playbook -i hosts main.yaml`


### TO-DO

* Insert v3 sample data (optional)
* Target OS check function
* S3 support for public API endpoint from Kilo to Newton.
* Generate command template
* Refine the client command from keystoneclient to openstack client from Liberty to Newton.
* Integrate with LXD 
