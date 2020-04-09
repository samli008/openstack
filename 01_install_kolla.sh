# install kolla-ansible for all nodes
yum -y install python-devel libffi-devel gcc openssl-devel libselinux-python git bash-completion net-tools python-pip ansible

cd /root/pip
pip install pip-19.1.1-py2.py3-none-any.whl
pip install kolla-ansible --ignore-installed PyYAML --no-index --find-links=/root/pip
pip install python-openstackclient --no-index --find-links=/root/pip
pip install decorator-4.4.0-py2.py3-none-any.whl

cd /root/kolla
pip install --no-index --find-links=/root/pip -r requirements.txt
cd /root/kolla-ansible
pip install --no-index --find-links=/root/pip -r requirements.txt

