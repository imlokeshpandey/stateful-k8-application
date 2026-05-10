# Deployment, Backup and Restore Guide

This document explains how to deploy, validate, back up and restore the Stateful Node.js + LevelDB application running on Kubernetes using OpenEBS LocalPV-LVM and Restic.

---

# Deployment Workflow

## Environment Assumptions

- Kubernetes worker nodes have attached block storage devices (NVMe SSD / HDD).
- OpenEBS LocalPV-LVM operates directly on worker-node local storage.
- LVM Volume Groups are configured locally on Kubernetes worker nodes.
- Kubernetes cluster and networking are already provisioned.

---

## Step 1 — Prepare LVM Storage

Initializes Physical Volumes (PV) and creates LVM Volume Groups for OpenEBS LocalPV-LVM storage provisioning.

```bash
chmod +x scripts/prepare-lvm.sh

./scripts/prepare-lvm.sh
```

---

## Step 2 — Install OpenEBS

Installs OpenEBS LocalPV-LVM components inside the Kubernetes cluster and enables dynamic LVM-backed PersistentVolume provisioning.

```bash
helm repo add openebs https://openebs.github.io/openebs

helm repo update

helm install openebs openebs/openebs \
-n openebs \
--create-namespace
```

---

## Step 3 — Build Application Image

Builds the Docker image for the Node.js + LevelDB application.

```bash
cd app

docker build -t leveldb-nodejs:v1 .

cd ..
```

---

## Step 4 — Deploy Kubernetes Resources

Deploys all Kubernetes manifests including:

- Namespace
- StatefulSet
- Service
- PersistentVolumeClaim
- Backup CronJob
- Restore resources

```bash
kubectl apply -f kubernetes/
```

---

## Step 5 — Verify Deployment

Verify StatefulSet pod and PersistentVolumeClaim status.

```bash
kubectl get pods -n leveldb-nodeapp-poc

kubectl get pvc -n leveldb-nodeapp-poc
```

---

# Application Validation Workflow

## Port Forward Application Service

Expose the Kubernetes service locally for testing.

```bash
kubectl port-forward svc/leveldb-service 3000:3000 \
-n leveldb-nodeapp-poc
```

---

## Write Test Data

Store sample data inside LevelDB persistent storage.

```bash
curl localhost:3000/write
```

---

## Read Stored Data

Validate persistent data stored inside the PVC-backed LevelDB volume.

```bash
curl localhost:3000/read
```

Expected output:

```text
hello-leveldb
```

---

# Backup Workflow

## Backup Architecture

The backup workflow is automated using Kubernetes CronJobs.

The backup pod:

- mounts the same PVC used by the StatefulSet application
- creates point-in-time LVM snapshots
- performs incremental Restic backups
- uploads backup data to remote object storage

Backup flow:

```text
CronJob
    |
    v
Mount PVC
    |
    v
LVM Snapshot
    |
    v
Restic Backup
    |
    v
S3 / MinIO Repository
```

---

## Backup Components

### Kubernetes CronJob

- Runs automated backups based on configured RPO.
- Creates temporary Kubernetes backup pods.

---

### PVC Mount

- Backup pod mounts the StatefulSet PVC.
- Provides access to OpenEBS-backed persistent storage.

---

### LVM Snapshot

- Creates point-in-time snapshots for consistent backups.
- Minimizes performance impact on running workloads.

---

### Restic Incremental Backup

- Performs incremental backups from snapshot volumes.
- Reduces backup transfer size and storage overhead.

---

### Remote Backup Repository

- Stores backup data in S3 / MinIO object storage.
- Enables disaster recovery outside Kubernetes worker nodes.

---

## Manual Backup Validation

Manual execution can be used during testing and validation.

```bash
chmod +x scripts/backup-test.sh

./scripts/backup-test.sh
```

---

## Verify Backup Job

```bash
kubectl get jobs -n leveldb-nodeapp-poc
```

---

## Verify Backup Logs

```bash
kubectl logs <backup-pod-name> \
-n leveldb-nodeapp-poc
```

---

# Restore Workflow

## Restore Architecture

The restore workflow retrieves backup data from the remote Restic repository and restores it into PersistentVolumeClaim storage.

Restore flow:

```text
Remote Repository
        |
        v
Restore Job
        |
        v
Restore PVC Data
        |
        v
Restart StatefulSet
```

---

## Restore Components

### Restore Job

- Connects to the remote Restic repository.
- Starts restore workflow for persistent data recovery.

---

### Restore Data To PVC

- Restores backup data directly into PVC storage.
- Makes restored data available to StatefulSet pods.

---

### Restart StatefulSet

- StatefulSet remounts restored persistent storage.
- Application restarts using recovered LevelDB data.

---

### Validate Restored Data

- Confirms successful recovery using application APIs.

---

## Manual Restore Validation

Manual restore workflow used for testing and disaster recovery validation.

```bash
chmod +x scripts/restore-test.sh

./scripts/restore-test.sh
```

---

## Restart StatefulSet

```bash
kubectl rollout restart statefulset leveldb-app \
-n leveldb-nodeapp-poc
```

---

## Validate Restored Data

```bash
curl localhost:3000/read
```

Expected output:

```text
hello-leveldb
```

---

# CI/CD Workflow

## Deployment Automation Flow

The deployment workflow can be automated using GitHub Actions.

CI/CD flow:

```text
GitHub Push
      |
      v
GitHub Actions Pipeline
      |
      v
Docker Image Build
      |
      v
Push Image To Registry
      |
      v
Deploy Kubernetes Manifests
      |
      v
StatefulSet Rolling Update
```

---

## CI/CD Workflow Steps

### GitHub Push

- Developer pushes application or Kubernetes manifest changes.

---

### GitHub Actions Pipeline

- Automatically triggers deployment workflow.

---

### Docker Image Build

- Builds updated Node.js application image.

---

### Push Image To Registry

- Pushes container image to Docker registry.

---

### Deploy Kubernetes Manifests

- Deploys updated Kubernetes resources.

---

### StatefulSet Rollout

- Kubernetes performs rolling updates for Stateful application pods.