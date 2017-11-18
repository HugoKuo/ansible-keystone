# ansible-keystone
To deploy OpenStack Keystone server with Ansible

* The keystone package installed from Ubuntu Cloud Archive
* This playbook supports Ubuntu x64 only.
* J to M supports Ubuntu Trusty 14.04.
* Newton, Ocata and Pike requires Ubuntu 16.04 Xenial. https://wiki.ubuntu.com/OpenStack/CloudArchive

### How to use it

* [ KS-juno | KS-kilo | KS-liberty | KS-mitaka]

0. prepare Ubuntu 1404 VM for above or earlier keystone version.
1. Specify the release version of openstack in main.yaml by the role.
2. Edit the inventory in hosts.
3. Edit the Swift endpoint in `roles/v2-data/vars/main.yaml`.
4. Sync the SSH-key to target host's swiftstack user.
5. Run the playbook `$ ansible-playbook -i hosts main.yaml`.

* [ KS-newton | KS-ocata | KS-pike | KS-queens (Staging Only)]

0. prepare Ubuntu 1604 VM for above or newer keystone version.
  1. e.g. use Vagrant file to setup VM on VirtualBox.
  2. e.g. use prep.sh for preparing all the required package for Keystone.
1. Specify the release version of openstack in main.yaml by the role.
2. Edit the Global Var - inventory, mysql username and password; keystone and swift endpoint ip address in hosts file and comment out `- v2-data` in main.yaml.
3. Edit the Role Level Var - keystone version in `roles/KS-{ksytone version}/vars/main.yaml` and `roles/KS-{keystone version}/tasks/2-keystone.yaml`.
4. Sync the SSH-key to target host's swiftstack user or just use prep.sh for your VM preparation.
5. Run the playbook `$ ansible-playbook -i hosts main.yaml`.

### Keystone Middleware Configuration Demo

* If you are using SwiftStack Keystone middleware, you have to enable `Keystone Auth` and `Keystone Auth Token Support`. The `Keystone Auth Token Support` configuration example (Assume my Keystone IP is 172.28.128.43) is as below.
![keystonemiddlewaredemo](https://user-images.githubusercontent.com/1863416/32983001-a4d40e30-cc42-11e7-8f2a-e2c378e07ecc.png)

* Then you could try the command as below should be able to allow you to use Keystone token as authentication.
```
swift --os-auth-url http://172.28.128.43:5000/v3 --auth-version 3 --os-project-name admin --os-project-domain-name Default --os-username admin --os-user-domain-name Default --os-password ADMIN stat -v
            StorageURL: http://172.28.128.42/v1/KEY_b405fae678f9442e88a5856d220617dd
            Auth Token: MIIIeAYJKoZIhvcNAQcCoIIIaTCCCGUCAQExDTALBglghkgBZQMEAgEwggbCBgkqhkiG9w0BBwGgggazBIIGr3sidG9rZW4iOnsiaXNfZG9tYWluIjpmYWxzZSwibWV0aG9kcyI6WyJwYXNzd29yZCJdLCJyb2xlcyI6W3siaWQiOiJhMWQ5YmI5OWM3NTA0Nzg3ODE5MWRkY2JhYjA5ZThlOSIsIm5hbWUiOiJzd2lmdG9wZXJhdG9yIn0seyJpZCI6IjdlMDM3ZGVlNTM1YjRiOWY4ZmFhOWVhYjQwMWVmNjdhIiwibmFtZSI6ImFkbWluIn0seyJpZCI6ImQ4YmY2NWJjYzdmZjQxODliY2Y0YjA3MWE2MDE5MzM4IiwibmFtZSI6IlJlc2VsbGVyQWRtaW4ifV0sImV4cGlyZXNfYXQiOiIyMDE3LTExLTE4VDE4OjEyOjE1LjAwMDAwMFoiLCJwcm9qZWN0Ijp7ImRvbWFpbiI6eyJpZCI6ImRlZmF1bHQiLCJuYW1lIjoiRGVmYXVsdCJ9LCJpZCI6ImI0MDVmYWU2NzhmOTQ0MmU4OGE1ODU2ZDIyMDYxN2RkIiwibmFtZSI6ImFkbWluIn0sImNhdGFsb2ciOlt7ImVuZHBvaW50cyI6W3sicmVnaW9uX2lkIjoiUmVnaW9uT25lIiwidXJsIjoiaHR0cDovLzE3Mi4yOC4xMjguNDIvdjEiLCJyZWdpb24iOiJSZWdpb25PbmUiLCJpbnRlcmZhY2UiOiJhZG1pbiIsImlkIjoiMDMyNTZkZDdhZjNmNDUxMWEwMDBkNTdiMGM0ZjY1ZmUifSx7InJlZ2lvbl9pZCI6IlJlZ2lvbk9uZSIsInVybCI6Imh0dHA6Ly8xNzIuMjguMTI4LjQyL3YxL0tFWV9iNDA1ZmFlNjc4Zjk0NDJlODhhNTg1NmQyMjA2MTdkZCIsInJlZ2lvbiI6IlJlZ2lvbk9uZSIsImludGVyZmFjZSI6ImludGVybmFsIiwiaWQiOiIwYWRjY2Y5NWRjNjg0MGI1OTA2OTcwMWVkNGUyNDczYSJ9LHsicmVnaW9uX2lkIjoiUmVnaW9uT25lIiwidXJsIjoiaHR0cDovLzE3Mi4yOC4xMjguNDIvdjEvS0VZX2I0MDVmYWU2NzhmOTQ0MmU4OGE1ODU2ZDIyMDYxN2RkIiwicmVnaW9uIjoiUmVnaW9uT25lIiwiaW50ZXJmYWNlIjoicHVibGljIiwiaWQiOiI3YjYzY2IzNGY4NDc0YTIzYjZmMDZhMDM4MjRiNGVhZSJ9XSwidHlwZSI6Im9iamVjdC1zdG9yZSIsImlkIjoiOGZiYjcwMmJhZjVjNDAyOTgzZjYwYjBmOGMxMDljMjAiLCJuYW1lIjoic3dpZnQifSx7ImVuZHBvaW50cyI6W3sicmVnaW9uX2lkIjoiUmVnaW9uT25lIiwidXJsIjoiaHR0cDovL2xvY2FsaG9zdDozNTM1Ny92My8iLCJyZWdpb24iOiJSZWdpb25PbmUiLCJpbnRlcmZhY2UiOiJpbnRlcm5hbCIsImlkIjoiMDRkMzlhZmRmZDJlNGZiNzkwODQ0MjY4MDRiZWQyNjQifSx7InJlZ2lvbl9pZCI6IlJlZ2lvbk9uZSIsInVybCI6Imh0dHA6Ly9sb2NhbGhvc3Q6MzUzNTcvdjMvIiwicmVnaW9uIjoiUmVnaW9uT25lIiwiaW50ZXJmYWNlIjoiYWRtaW4iLCJpZCI6IjZmODdkZjkzNmRjODQ1ZDNiNWY0MTZmM2MxZjMyMjAzIn0seyJyZWdpb25faWQiOiJSZWdpb25PbmUiLCJ1cmwiOiJodHRwOi8vbG9jYWxob3N0OjUwMDAvdjMvIiwicmVnaW9uIjoiUmVnaW9uT25lIiwiaW50ZXJmYWNlIjoicHVibGljIiwiaWQiOiI5MWQ3YmRiNzQwNjM0MDEyOTI2Y2M3YTg2MDk1MzU5MyJ9XSwidHlwZSI6ImlkZW50aXR5IiwiaWQiOiI5NmMxMTVjMWQxMGY0ZWM3OWY5M2NmNjRkMGM5MzBjYyIsIm5hbWUiOiJrZXlzdG9uZSJ9XSwidXNlciI6eyJkb21haW4iOnsiaWQiOiJkZWZhdWx0IiwibmFtZSI6IkRlZmF1bHQifSwiaWQiOiJmZTBhYTU5MjA0N2E0ZmVjYjY2YjFlZTQwZTkwZjIxNCIsIm5hbWUiOiJhZG1pbiJ9LCJhdWRpdF9pZHMiOlsic1ZrMHFJcWNRUHVVU3dBa0l3NjUwQSJdLCJpc3N1ZWRfYXQiOiIyMDE3LTExLTE4VDE3OjEyOjE1LjAwMDAwMFoifX0xggGJMIIBhQIBATBgMFsxCzAJBgNVBAYTAlVTMQ4wDAYDVQQIDAVVbnNldDEOMAwGA1UEBwwFVW5zZXQxDjAMBgNVBAoMBVVuc2V0MRwwGgYDVQQDDBNzczAzLnN3aWZ0c3RhY2suaWR2AgEBMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQCuzJbCfxS82XLmg2jTXDJ+ytVZFq7O6dCnMn5Jil5BOTJcbzMC3L5F8H87cUJsRcEUIt30afYypgK7TSyajr+mSxGVTdwHlx4ZQVmFbTq324KzYz14l0jLx2aN5sEW8-G385AIn+fO1eQqY9Lw9J8YZ4nfl+N5nExw0gL11wnoGCBD+UA39Q4CjT0r5Sxr-xxQ9Tpm376TzSGx2Vk8broGiepvc2b9i440gKRqk8DUyE-in+pCSCZ6XkZmFNjpV1IRhgbdSxOd23zMFeXbridOM89h5bSHuEcD81kO+0Shz-fuSl0F10eSeuPf05-gN6H1rVC0kuPDS5uLXOCPc71p
               Account: KEY_b405fae678f9442e88a5856d220617dd
            Containers: 0
               Objects: 0
                 Bytes: 0
       X-Put-Timestamp: 1511025133.37529
           X-Timestamp: 1511025133.37529
            X-Trans-Id: tx88577f8656fa4cac9d81e-005a1069ec
          Content-Type: text/plain; charset=utf-8
X-Openstack-Request-Id: tx88577f8656fa4cac9d81e-005a1069ec
```


### PS - For PKI token

* [ KS-newton(only) ]

0. We provide a `PKI` token option except the default `Fernet` token. However you have to update `ansible-keystone/roles/KS-newton/vars/main.yaml` to update from `TOKEN_VERSION: fernet` to `TOKEN_VERSION: pki`.

### TO-DO

* Insert v3 sample data (optional)
* Target OS check function
* S3 support for public API endpoint from Kilo to Newton.
* Generate command template
* ~~Refine the client command from keystoneclient to openstack client from Liberty to Newton.~~
* Integrate with LXD
