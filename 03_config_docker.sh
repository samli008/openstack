sed -i 's|ExecStart=/usr/bin/dockerd|ExecStart=/usr/bin/dockerd --insecure-registry 192.168.20.143:4000|g' /usr/lib/systemd/system/docker.service

cd /etc/systemd/system/
mkdir docker.service.d
cd docker.service.d

cat > kolla.conf << EOF
[Service]
MountFlags=shared
EOF

systemctl daemon-reload
systemctl restart docker
systemctl enable docker
