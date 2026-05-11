#Infrastructure Provisioning

This project assumes an existing Kubernetes environment for the Stateful application deployment.

Note:- We can use pulumi also based on requirements we have like Kubernetes Heavy infra.

Terraform can be used to automate:

- bare-metal VM provisioning
- Kubernetes control-plane setup
- worker-node provisioning
- network configuration
- storage node preparation

Example infrastructure flow:

```text
Terraform
    |
    v
Provision Bare-Metal Nodes
    |
    v
Bootstrap Kubernetes Cluster
    |
    v
Install OpenEBS
    |
    v
Deploy Stateful Application
```

Potential future Terraform modules:

```text
terraform/
├── provider.tf
├── variables.tf
├── main.tf
├── control-plane.tf
├── workers.tf
└── modules/
```

## Step 1 — Prepare LVM Storage - MANUAL APPROACH for POC Purpose only.

Initializes Physical Volumes (PV) and creates LVM Volume Groups for OpenEBS LocalPV-LVM storage provisioning.

### Manual PoC Setup

For PoC and local testing environments, LVM storage can be prepared manually using the provided bootstrap script.

```bash
chmod +x scripts/prepare-lvm.sh

./scripts/prepare-lvm.sh
```

---

### Production Automation Approach

In production environments, worker-node LVM preparation can be automated using configuration management tools such as Ansible during Kubernetes node bootstrap.

Typical automation scope:

- install `lvm2` packages
- initialize Physical Volumes (PV)
- create Volume Groups (VG)
- prepare storage for OpenEBS LocalPV-LVM
