registry_server=registry

docker load -i ../images/eck_1_6.tar
docker tag docker.elastic.co/eck/eck-operator:1.6.0 $registry_server:5000/eck-operator:1.6.0
docker push $registry_server:5000/eck-operator:1.6.0