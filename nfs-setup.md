# setup NFS share

```
sudo yum -y install nfs-utils
sudo systemctl enable --now nfs-server
sudo mkdir -p /data/nfs_shares
sudo chown -R nobody: /data/nfs_shares
sudo chmod -R 777 /data/nfs_shares
sudo systemctl restart nfs-utils.service
sudo vi /etc/exports
/data/nfs_shares    *(rw,sync,no_subtree_check,no_root_squash,no_all_squash,insecure)
sudo exportfs -arv
sudo exportfs -s

```

# test NFS share 
```
sudo dnf install nfs-utils nfs4-acl-tools -y
showmount -e 192.168.56.106

sudo mkdir p /mnt/client_share
sudo mount -t nfs 192.168.56.106:/data/nfs_shares /mnt/client_share
```

# Setup NFS Provisioner for Kubernetes

```
helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/
helm install nfs-subdir-external-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
    --set nfs.server=192.168.56.106 \
    --set nfs.path=/data/nfs_shares \
    --set storageClass.name=standard

```

# make default sc
```
kubectl patch storageclass standard -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'

```