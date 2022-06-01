# Three servers (one of which is the primary server)
## Install Docker
    <sh  in_docker.sh>
    
## Install  Kubernetes
### Basic environment
#### Set each machine's own hostname
      <hostnamectl set-hostname xxx>
      <sh Ba_en.sh>
      
### Install kubelet、kubeadm、kubectl
      <sh in_ku.sh>    
#### All machines are configured with master domain name(own host IP address)
      <echo "172.31.0.2  master" >> /etc/hosts>
      
### Initialize the master node(own host IP address)
#### Initialize 
      <kubeadm init \
        --apiserver-advertise-address=172.31.0.2 \
        --control-plane-endpoint=master \
        --image-repository registry.cn-hangzhou.aliyuncs.com/lfy_k8s_images \
        --kubernetes-version v1.20.9 \
        --service-cidr=10.96.0.0/16 \
        --pod-network-cidr=192.168.0.0/16>
        
#### mkdir
      <mkdir -p $HOME/.kube
       sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
       sudo chown $(id -u):$(id -g) $HOME/.kube/config>

#### Install Calico Network Plugin
      <kubectl apply -f calico.yaml>
      
#### Join worker nodes (two nodes)
      <kubeadm join master:6443 --token h5nvs4.p72ob4gg2sgkx69x \
       --discovery-token-ca-cert-hash sha256:d36bab9d723a33fc6a914948c25ef39ebe0235678bfe19cbb9882b3bca48dc45>
       
## Install neo4j
    <sh in_neo4j.sh>

## Install Kafka
    <sh in_kafka.sh>

## Install KubeSphere pre-environment
### nfs file system
#### on each machine.
      <yum install -y nfs-utils>
      
#### Execute the following command on the master
      <echo "/nfs/data/ *(insecure,rw,sync,no_root_squash)" > /etc/exports>

#### Execute the following commands to start the nfs service; create a shared directory
      <mkdir -p /nfs/data>

#### Execute on master
      <systemctl enable rpcbind
       systemctl enable nfs-server
       systemctl start rpcbind
       systemctl start nfs-server>

#### make the configuration take effect
      <exportfs -r>

#### Check if the configuration takes effect
      <exportfs>

### Configure nfs-client (nodes)(own host IP address)
      <showmount -e 172.31.0.2
       mkdir -p /nfs/data
       mount -t nfs 172.31.0.2:/nfs/data /nfs/data>

### Install Configure default storage (configure default storage class for dynamic provisioning)(Be careful to change the IP address)
      <kubectl apply -f sc.yaml>

### Install metrics-server (cluster metrics monitoring component)(Be careful to change the IP address)
      <kubectl apply -f metrics-server.yaml>

## Install KubeSphere
### Install kubesphere-installer(Be careful to change the IP address)
      <kubectl apply -f kubesphere-installer.yaml>
      
### Install cluster-configuration(Be careful to change the IP address)
      <kubectl apply -f cluster-configuration.yaml>
#### Install etcd monitoring certificate
      <kubectl logs -n kubesphere-system $(kubectl get pod -n kubesphere-system -l app=ks-install -o         jsonpath='{.items[0].metadata.name}') -f>

#### Access port 30880 of any server
     Account: admin
     Password: P@88w0rd

﻿
​



