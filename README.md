# Elastic ECK Installation

This ECK Elastic Stack install instruction

Installation will assume offline airgap environment installation. 

## PreProcess

1. Install Kubernetes 

2. Install helm
```
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
```
3. Install Elasticsearch using helm

```
helm install elasticsearch elastic/elasticsearch --set imageTag=7.14.0 --set replicas=5


# or
helm install elasticsearch elastic/elasticsearch -f ./helm/es-values.yaml


```

4. From airgaped environment, push downloaded image to offline environment docker private registry. 

```
cd images
docker load -i eck_1_6.tar
docker tag docker.elastic.co/eck/eck-operator:1.6.0 [your_registry]:5000/eck-operator:1.6.0
docker push [your_registry]:5000/eck-operator:1.6.0
```
## Installation

1. ECK install

Edit eck.yaml for custom configuration

For docker private registry customization 

```
apiVersion: v1
kind: ConfigMap
metadata:
  name: elastic-operator
  namespace: elastic-system
  labels:
    control-plane: elastic-operator
    app.kubernetes.io/version: "1.6.0"
data:
  eck.yaml: |-
    log-verbosity: 0
    metrics-port: 0
    container-registry: registry:5000
    max-concurrent-reconciles: 3
    ca-cert-validity: 8760h
    ca-cert-rotate-before: 24h
    cert-validity: 8760h
    cert-rotate-before: 24h
    set-default-security-context: true
    kube-client-timeout: 60s
    elasticsearch-client-timeout: 180s
    disable-telemetry: false
    validate-storage-class: true
    enable-webhook: true
    webhook-name: elastic-webhook.k8s.elastic.co
```

deploy the eck operator to kubernetes
```
kubectl apply -f yaml/eck.yaml
```

2. Install Elastic Search 
Each host should be configured vm.max_map_count=262144
```
sudo sysctl -w vm.max_map_count=262144
```
configure and edit elastic.yaml and deploy
```
kubectl apply -f yaml/elastic.yaml
```
3. Install Kibana 

4. Install APM Server

5. Install Agent 



