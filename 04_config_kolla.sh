# config kolla-ansible 
mkdir -p /etc/kolla
cd /etc/kolla
cp -r /usr/share/kolla-ansible/etc_examples/kolla/* .

mkdir -p /etc/kolla/config

cd /etc/kolla/
kolla-genpwd
sed -i 's/^keystone_admin.*/keystone_admin_password: admin/' passwords.yml

cat > /etc/ansible/ansible.cfg << EOF
[defaults]
forks = 100
host_key_checking = False
pipelining = True
EOF

cat > /etc/kolla/globals.yml << EOF
---
kolla_base_distro: "centos"
kolla_install_type: "source"
openstack_release: "rocky"
kolla_internal_vip_address: "192.168.50.115"
docker_registry: "192.168.50.14:4000"
docker_namespace: "kolla"
network_interface: "eth0"
neutron_external_interface: "eth1"
enable_cinder: "yes"
keepalived_virtual_router_id: "57"
ironic_dnsmasq_dhcp_range:
tempest_image_id:
tempest_flavor_ref_id:
tempest_public_network_id:
tempest_floating_network_name:
EOF

