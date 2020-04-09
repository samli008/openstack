# set openstack pool
ceph auth get-or-create client.glance mon 'allow r' osd 'allow class-read object_prefix rdb_children, allow rwx pool=images' -o /etc/ceph/ceph.client.glance.keyring

ceph auth get-or-create client.cinder mon 'allow r' osd 'allow class-read object_prefix rbd_children, allow rwx pool=volumes, allow rx pool=images' -o /etc/ceph/ceph.client.cinder.keyring

ceph auth get-or-create client.cinder-backup mon 'allow r' osd 'allow class-read object_prefix rbd_children, allow rwx pool=backups' -o /etc/ceph/ceph.client.cinder-backup.keyring

ceph auth get-or-create client.nova mon 'allow r' osd 'allow class-read object_prefix rbd_children, allow rwx pool=vms, allow rx pool=images' -o /etc/ceph/ceph.client.nova.keyring

cd /etc/kolla/config
mkdir glance cinder nova
mkdir cinder/cinder-backup
mkdir cinder/cinder-volume

#glance config

cat > /etc/kolla/config/glance/glance-api.conf << EOF
[glance_store]
stores = rbd
default_store = rbd
rbd_store_pool = images
rbd_store_user = glance
rbd_store_ceph_conf = /etc/ceph/ceph.conf
EOF

cp /etc/ceph/ceph.conf /etc/kolla/config/glance/
cp /etc/ceph/ceph.client.glance.keyring /etc/kolla/config/glance/ceph.client.glance.keyring

#cinder config
a=`cat /etc/kolla/passwords.yml |grep cinder_rbd_secret_uuid |awk '{print $2}'`

cat > /etc/kolla/config/cinder/cinder-volume.conf << EOF
[DEFAULT]
enabled_backends=rbd-1

[rbd-1]
rbd_ceph_conf=/etc/ceph/ceph.conf
rbd_user=cinder
backend_host=rbd:volumes
rbd_pool=volumes
volume_backend_name=rbd-1
volume_driver=cinder.volume.drivers.rbd.RBDDriver
rbd_secret_uuid = $a
EOF

#cinder_rbd_secret_uuid can be found in /etc/kolla/passwords.yml file.


cat > /etc/kolla/config/cinder/cinder-backup.conf << EOF
[DEFAULT]
backup_ceph_conf=/etc/ceph/ceph.conf
backup_ceph_user=cinder-backup
backup_ceph_chunk_size = 134217728
backup_ceph_pool=backups
backup_driver = cinder.backup.drivers.ceph
backup_ceph_stripe_unit = 0
backup_ceph_stripe_count = 0
restore_discard_excess_bytes = true
EOF

cp /etc/ceph/ceph.conf /etc/kolla/config/cinder/

cp /etc/ceph/ceph.client.cinder.keyring /etc/kolla/config/cinder/cinder-backup/ceph.client.cinder.keyring
cp /etc/ceph/ceph.client.cinder.keyring /etc/kolla/config/cinder/cinder-volume/ceph.client.cinder.keyring
cp /etc/ceph/ceph.client.cinder-backup.keyring /etc/kolla/config/cinder/cinder-backup/ceph.client.cinder-backup.keyring

#nova config

cat > /etc/kolla/config/nova/nova-compute.conf << EOF
[libvirt]
images_rbd_pool=vms
images_type=rbd
images_rbd_ceph_conf=/etc/ceph/ceph.conf
rbd_user=nova
EOF

cp /etc/ceph/ceph.conf /etc/kolla/config/nova/
cp /etc/ceph/ceph.client.nova.keyring /etc/kolla/config/nova/ceph.client.nova.keyring
cp /etc/ceph/ceph.client.cinder.keyring /etc/kolla/config/nova/

cat >> /etc/kolla/globals.yml << EOF
enable_ceph: "no"
glance_backend_ceph: "yes"
cinder_backend_ceph: "yes"
nova_backend_ceph: "yes"
EOF
