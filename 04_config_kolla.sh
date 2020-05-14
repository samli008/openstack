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

# config external storage
mkdir -p /etc/kolla/config
cd /etc/kolla/config

cat > ceph.conf << EOF
osd pool default size = 2
osd journal size = 2000
mon clock drift allowed = 2
mon clock drift warn backoff = 30
mon allow pool delete = true
EOF

cat > nfs_shares << EOF
storage01:/kvm/nfs
EOF

cat >> /etc/hosts << EOF
192.168.100.62 storage01
EOF

# config kolla global.yml
cat > /etc/kolla/globals.yml << EOF
---
kolla_base_distro: "centos"
kolla_install_type: "source"
openstack_release: "rocky"
kolla_internal_vip_address: "192.168.6.63"
docker_registry: "192.168.6.41:4000"
docker_namespace: "kolla"
network_interface: "em1"
neutron_external_interface: "em2"
enable_cinder: "yes"
#enable_cinder_backend_nfs: "yes"
keepalived_virtual_router_id: "57"
ironic_dnsmasq_dhcp_range:
tempest_image_id:
tempest_flavor_ref_id:
tempest_public_network_id:
tempest_floating_network_name:
EOF
