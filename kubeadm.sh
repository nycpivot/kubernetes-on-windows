read -p "Node IP: " advertise_address
read -p "Node Name: " node_name

cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

sudo sysctl --system

cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

sudo systemctl --system
sudo apt-get update && sudo apt-get install -y containerd
sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml
sudo systemctl restart containerd
sudo systemctl status containerd

sudo apt-get update && sudo apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

cat <<EOF | sudo tee kubeadm.yaml
apiVersion: kubeadm.k8s.io/v1beta2
kind: InitConfiguration
localAPIEndpoint:
  advertiseAddress: $advertise_address
  bindPort: 6443
nodeRegistration:
  name: $node_name
  taints:
  - effect: NoSchedule
    key: node-role.kubernetes.io/master
  criSocket: /var/run/containerd/containerd.sock
EOF

swapoff -a

sudo modprobe br_netfilter
sudo kubeadm init --config=kubeadm.yaml


AFTER SPINNING UP A WINDOWS MACHINE - RUN WINDOWS UPDATE

HAVING TROUBLE LISTING, RUNNING CONTAINERS IN A NAMESPACE
WHY NOT USING WINDOWS SERVER CORE?

I just dump kubectl in system32 and .kube/config in users\[user] folder

DownloadFile isnt a PS command, use
Invoke-WebRequest -Uri https://k8stestinfrabinaries.blob.core.windows.net/nssm-mirror/nssm-2.24.zip -OutFile nssm-2.24.zip



9/25/2021 1:35 AM Installing OVS driver certificate.

Import-Certificate : Access is denied. (Exception from HRESULT: 0x80070005 (E_ACCESSDENIED))
At C:\Users\mjames\Install-OVS.ps1:153 char:9
+         Import-Certificate -FilePath "$CertificateFile" -CertStoreLoc ...
+         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : NotSpecified: (:) [Import-Certificate], UnauthorizedAccessException
    + FullyQualifiedErrorId : System.UnauthorizedAccessException,Microsoft.CertificateServices.Commands.ImportCertific
   ateCommand
   
   
Had to use certutil, powershell cmd failed

