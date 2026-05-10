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
