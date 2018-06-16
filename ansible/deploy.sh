# Install NGINX and Apache roles from repo
ansible-galaxy install geerlingguy.apache
ansible-galaxy install geerlingguy.nginx

# Copy over Azure credentials and ssh keys
scp /home/tomas/.ssh/id_rsa tomas@104.214.231.71:~/.ssh/
scp -pr /home/tomas/.azure/ tomas@104.214.231.71:~/.azure/

# Run play-book
export ANSIBLE_HOST_KEY_CHECKING=False
ansible-playbook main.yaml

# Using something else to deploy infrastructure? Gather Azure details with dynamic inventory
wget https://raw.githubusercontent.com/ansible/ansible/devel/contrib/inventory/azure_rm.py
chmod +x azure_rm.py

./azure_rm.py | jq

ansible -i azure_rm.py ansiblegroup_nginx -m ping