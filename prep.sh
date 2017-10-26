sudo apt-get install software-properties-common -y
sudo apt-add-repository ppa:ansible/ansible -y
sudo apt-get update -y
sudo apt-get install ansible git -y
#adduser swiftstack
#usermod -aG sudo swiftstack
#sudo su swiftstack
#ssh-keygen -t rsa -b 4096 -C "swiftstack@ss01"
#cat /home/swiftstack/.ssh/id_rsa.pub >> /home/swiftstack/.ssh/authorized_keys
ssh-keygen -t rsa -b 4096 -C "root@ss01"
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

#source ./roles/KS-kilo/files/source_file/*
