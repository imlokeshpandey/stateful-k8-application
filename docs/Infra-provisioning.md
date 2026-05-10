# Bare-Metal Infrastructure Provisioning Flow

1. Provision bare-metal VMs or worker nodes using Terraform.
2. Install OpenEBS LocalPV-LVM components.
3. Prepare LVM storage on Kubernetes worker nodes.
4. Deploy StorageClass and PersistentVolumeClaim resources.
5. Build and deploy Stateful application manifests.
