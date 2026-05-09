# Bare-Metal Infrastructure Provisioning Flow

1. Provision bare-metal VMs or worker nodes using Terraform.
2. Configure networking and Kubernetes node prerequisites.
3. Bootstrap Kubernetes control plane and worker nodes.
4. Install OpenEBS LocalPV-LVM components.
5. Prepare LVM storage on Kubernetes worker nodes.
6. Deploy StorageClass and PersistentVolumeClaim resources.
7. Build and deploy Stateful application manifests.