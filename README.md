# What This Project Demonstrates
Stateful Kubernetes PoC using Node.js + LevelDB with OpenEBS LocalPV-LVM, Restic backups and disaster recovery workflows.

Below are some strategies on how to deploy a stateful Node.js application using embedded LevelDB on Kubernetes with:

- Kubernetes StatefulSet deployment
- OpenEBS LocalPV-LVM dynamic provisioning
- LVM-backed persistent storage
- PersistentVolumeClaim-based storage mounting
- Readiness and liveness health probes
- Restic backup automation with six-hour RPO
- Backup restore workflows
- Kubernetes storage architecture
- Pod failure recovery validation
- Node failure recovery strategy

---

# Architecture Overview

```text
Client
    |
    v
Kubernetes Service
    |
    v
StatefulSet Pod
    |
    v
PersistentVolumeClaim (PVC)
    |
    v
OpenEBS LVM CSI
    |
    v
LVM Volume Group
    |
    v
Physical NVMe SSD
```

---

# Prerequisites

- Kubernetes cluster - BM/VM 
- kubectl configured
- Helm installed
- OpenEBS installed
- Available worker-node disk for LVM
- Linux nodes with LVM2 installed
- Docker installed for building Node.js image

---

# Infrastructure Preparation

## Infrastructure Provisioning Assumption

This PoC assumes the Kubernetes cluster and worker nodes are already provisioned.

In production environments, infrastructure provisioning can be automated using Terraform for:

- bare-metal VM provisioning
- Kubernetes control-plane and worker-node setup
- network configuration
- storage node preparation

The following steps demonstrate manual LVM preparation on Kubernetes worker nodes for OpenEBS LocalPV-LVM storage.

---

## Create LVM Physical Volume

```bash
pvcreate /dev/nvme1n1
```

---

## Create Volume Group

```bash
vgcreate lvmvg1 /dev/nvme1n1
```

---

# Project Structure

```text
leveldb-k8s-poc/
│
├── README.md
│
├── app/
│   ├── Dockerfile
│   ├── package.json
│   ├── package-lock.json
│   └── server.js
│
├── kubernetes/
│   ├── namespace.yaml
│   ├── storageclass.yaml
│   ├── pvc.yaml
│   ├── service.yaml
│   ├── statefulset.yaml
│   ├── backup-secret.yaml
│   ├── backup-cronjob.yaml
│
├── diagrams/
│   ├── architecture.png
│   ├── ci-cd.png
│   ├── backup_restore-flow.png
│   └── observability.png
│
└── scripts/
    └── prepare-lvm.sh
```
Future horizontal scaling approaches or enhancements:

- application-aware sharding
- read-only replica patterns
- external synchronization services
