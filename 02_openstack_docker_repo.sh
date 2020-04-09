# create local openstack repository
tar xzvf registry.tar -C /opt/
docker load < registry2.tar
docker run -d -v /opt/registry:/var/lib/registry --name registry --restart always -p 4000:5000 registry:2
curl http://localhost:4000/v2/_catalog
