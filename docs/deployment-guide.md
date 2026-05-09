# Deployment, Backup and Restore Guide

## Deployment Workflow

## MANUAL WORKFLOW FOR TESTING 

### Prepare LVM Storage

- Initializes Physical Volumes (PV).
- Creates LVM Volume Group for OpenEBS LocalPV-LVM storage.

## Kubernetes Worker Nodes

- Kubernetes worker nodes are assumed to have attached block storage devices (NVMe SSD / HDD).
- OpenEBS LocalPV-LVM operates directly on worker-node local storage.

---


```bash
chmod +x scripts/prepare-lvm.sh

./scripts/prepare-lvm.sh
```

---

### Install OpenEBS

- Installs OpenEBS LocalPV-LVM components inside Kubernetes cluster.
- Enables dynamic LVM-backed PersistentVolume provisioning.

```bash
helm repo add openebs https://openebs.github.io/openebs

helm repo update

helm install openebs openebs/openebs \
-n openebs \
--create-namespace
```

---

### Build Application Image

- Builds Docker image for Node.js + LevelDB application.

```bash
cd app

docker build -t leveldb-nodejs:v1 .

cd ..
```

---

### Deploy Kubernetes Resources

- Deploys Namespace, StatefulSet, PVC, Service, Backup CronJob and Restore resources.

```bash
kubectl apply -f kubernetes/
```

---

### Verify Deployment

- Verifies StatefulSet pod and PVC status.

```bash
kubectl get pods -n leveldb-nodeapp-poc

kubectl get pvc -n leveldb-nodeapp-poc
```

---

# Application Runtime Workflow

### Port Forward Service

- Exposes Kubernetes service locally for testing.

```bash
kubectl port-forward svc/leveldb-service 3000:3000 \
-n leveldb-nodeapp-poc
```

---

### Write Test Data

- Writes sample data into LevelDB persistent storage.

```bash
curl localhost:3000/write
```

---

### Read Stored Data

- Validates persistent data stored inside PVC-backed LevelDB.

```bash
curl localhost:3000/read
```

Expected:

```text
hello-leveldb
```

---

# Backup Workflow

## Kubernetes CronJob

- Runs backup workflow automatically based on configured RPO.
- Creates temporary Kubernetes backup pod.

---

## Mount PersistentVolumeClaim

- Backup pod mounts the same PVC used by StatefulSet application.
- Provides access to OpenEBS-backed persistent storage.

---

## Create LVM Snapshot

- Backup script creates point-in-time LVM snapshot of active LevelDB volume.
- Minimizes performance impact on running workloads.

---

## Restic Incremental Backup

- Restic performs incremental backup against mounted snapshot volume.
- Reduces backup transfer size and IO overhead.

---

## Remote Repository Upload

- Backup snapshots are uploaded to remote object storage (S3 / MinIO).
- Provides disaster recovery capability outside Kubernetes nodes.

---

### Trigger Manual Backup

```bash
chmod +x scripts/backup-test.sh

./scripts/backup-test.sh
```

---

### Verify Backup Job

```bash
kubectl get jobs -n leveldb-nodeapp-poc
```

---

### Verify Backup Logs

```bash
kubectl logs <backup-pod-name> \
-n leveldb-nodeapp-poc
```

---

# Restore Workflow

## Trigger Restore Job

- Kubernetes restore job connects to remote Restic repository.
- Starts restore workflow for persistent storage recovery.

---

## Restore Data To PVC

- Restic restores backup data directly into PersistentVolumeClaim storage.
- Restored data becomes available to StatefulSet pods.

---

## Restart StatefulSet

- StatefulSet pod remounts restored persistent storage.
- Application restarts using recovered LevelDB data.

---

## Validate Restored Data

- Application API validates successful restore operation.

---

### Trigger Restore

```bash
chmod +x scripts/restore-test.sh

./scripts/restore-test.sh
```

---

### Restart StatefulSet

```bash
kubectl rollout restart statefulset leveldb-app \
-n leveldb-nodeapp-poc
```

---

### Validate Restored Data

```bash
curl localhost:3000/read
```

Expected:

```text
hello-leveldb
```

---

# CI/CD Workflow - AUTOMATION

## GitHub Push

- Developer pushes application or Kubernetes manifest changes to GitHub repository.

---

## GitHub Actions Pipeline

- CI/CD pipeline automatically starts deployment workflow.

---

## Docker Image Build

- Builds updated Node.js application image.

---

## Push Image To Registry

- Pushes container image to Docker registry.

---

## Deploy Kubernetes Manifests

- Deploys updated StatefulSet and Kubernetes resources.

---

## StatefulSet Rollout

- Kubernetes performs rolling update of application pods.

---
