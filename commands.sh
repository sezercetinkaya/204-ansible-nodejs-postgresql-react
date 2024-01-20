####### TERRAFORM #######
# Change the 'mykey' variable according to your key-pair without its 'pem' extention

####### CONTROL NODE CONFIGURATION #######
# Add IAM role to the control node (AmazonEC2FullAccess and AmazonSSMManagedInstanceCore)
# We add the roles to have a dynamic inventory with ansible and to encrypt our secrets with AWS Systems Manager Parameter Store
# Connect to the control node over ssh
sudo yum install git -y
git clone https://github.com/Yunus-Altay/204-Ansible-publish-website-postgresql-nodejs-react.git
# Check out the 'Config-files' folder
# Edit the ansible config file accordingly to connect to the hosts and to use ansible-roles
# Edit the dynamic inventory accordingly
ansible all -m ping -o # check the hosts
ansible-inventory --graph # check the dynamic inventory

####### FOR SEPARATE PLAYBOOKS #######
cd ~/204-Ansible-publish-website-postgresql-nodejs-react/Separate_playbooks
ansible-playbook docker-installation-centos.yaml
ansible development -m shell -a "docker -v"
# Ansible-vault file was created earlier
# It is cloned in here from the GitHub repo
chmod +x ./vault_passwd.sh
ansible-playbook postgres-playbook.yaml --vault-password-file ./vault_passwd.sh
ansible _ansible_postgresql -m shell -a "docker images" # check whether the image is created
ansible _ansible_postgresql -m shell -a "docker ps" # check the status of the container
ansible-playbook nodejs-playbook.yaml
ansible _ansible_postgresql -m shell -a "docker images" # check whether the image is created
ansible _ansible_postgresql -m shell -a "docker ps" # check the status of the container
ansible-playbook react-playbook.yaml
ansible _ansible_postgresql -m shell -a "docker images" # check whether the image is created
ansible _ansible_postgresql -m shell -a "docker ps" # check the status of the container
# Check the url ==> <ReactServer-PublicIP:3000>

####### FOR SINGLE PLAYBOOK #######
cd ~/204-Ansible-publish-website-postgresql-nodejs-react/Single_playbook
chmod +x ./vault_passwd.sh
ansible-playbook app-playbook.yaml --vault-password-file ./vault_passwd.sh
ansible development -m shell -a "docker -v && docker images && docker ps" 
# check whether docker is installed, images are built and the status of the containers
# Check the url ==> <ReactServer-PublicIP:3000>

####### FOR ROLE PLAYBOOK #######
cd ~/204-Ansible-publish-website-postgresql-nodejs-react/Role_playbook
chmod +x ./vault_passwd.sh
ansible-playbook app-role-playbook.yaml --vault-password-file ./vault_passwd.sh
# Check the url ==> <ReactServer-PublicIP:3000>