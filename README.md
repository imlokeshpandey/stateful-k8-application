## What This Project Demonstrates

This PoC demonstrates how to deploy a stateful Node.js application using embedded LevelDB on Kubernetes with:

- Kubernetes StatefulSet deployment
- OpenEBS LocalPV-LVM dynamic provisioning
- LVM-backed persistent storage
- PersistentVolumeClaim-based storage mounting
- Readiness and liveness health probes
- Restic backup automation with six-hour RPO
- Backup restore workflows
- Bare-metal Kubernetes storage architecture
- Pod failure recovery validation
- Node failure recovery strategy

## Architecture Overview

Client
→ Kubernetes Service
→ StatefulSet Pod
→ PVC
→ OpenEBS LVM CSI
→ LVM Volume Group
→ Physical NVMe SSD


## Prerequisites

- Kubernetes cluster (bare metal or VM-based)
- kubectl configured
- Helm installed
- OpenEBS installed
- Available worker-node disk for LVM
- Linux nodes with LVM2 installed
- Docker installed for building Node.js image

## Infrastructure Preparation

### Create LVM Physical Volume

```bash
pvcreate /dev/nvme1n1
```

### Create Volume Group

```bash
vgcreate lvmvg1 /dev/nvme1n1
```


block.

---



## Project Structure

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
│
├── diagrams/
│   ├── architecture.png
│   ├── deployment-flow.png
│   ├── backup-flow.png
│   └── recovery-flow.png
│
└── scripts/
    └── prepare-lvm.sh
