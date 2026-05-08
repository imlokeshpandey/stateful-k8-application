# Quick Deployment Steps

## 1. Prepare LVM Storage

Make script executable:

```bash
chmod +x scripts/prepare-lvm.sh
```

Run LVM preparation:

```bash
./scripts/prepare-lvm.sh
```

Verify Volume Group:

```bash
vgs
```

---

## 2. Install OpenEBS

Add Helm repository:

```bash
helm repo add openebs https://openebs.github.io/openebs
```

Update repositories:

```bash
helm repo update
```

Install OpenEBS:

```bash
helm install openebs openebs/openebs \
-n openebs \
--create-namespace
```

Verify installation:

```bash
kubectl get pods -n openebs
```

---

## 3. Build Application Image

Navigate to app directory:

```bash
cd app
```

Build Docker image:

```bash
docker build -t leveldb-nodejs:v1 .
```

Return to repository root:

```bash
cd ..
```

---

## 4. Deploy Kubernetes Resources

Deploy manifests:

```bash
kubectl apply -f kubernetes/
```

---

## 5. Verify Storage

Check PVC:

```bash
kubectl get pvc -n leveldb-nodeapp-poc
```

Expected:

```text
STATUS = Bound
```

---

## 6. Verify Stateful Application

Check pods:

```bash
kubectl get pods -n leveldb-nodeapp-poc
```

Expected:

```text
leveldb-app-0   Running
```

---

## 7. Access Application

Port-forward service:

```bash
kubectl port-forward svc/leveldb-service 3000:3000 \
-n leveldb-nodeapp-poc
```

---

## 8. Write Test Data

```bash
curl localhost:3000/write
```

---

## 9. Read Stored Data

```bash
curl localhost:3000/read
```

Expected:

```text
hello-leveldb
```

---

## 10. Validate Persistence

Delete pod:

```bash
kubectl delete pod leveldb-app-0 \
-n leveldb-nodeapp-poc
```

Wait for pod recreation:

```bash
kubectl get pods -n leveldb-nodeapp-poc
```

Read data again:

```bash
curl localhost:3000/read
```

Expected:

```text
hello-leveldb
```

---

## 11. Trigger Backup

Make backup script executable:

```bash
chmod +x scripts/backup-test.sh
```

Run backup:

```bash
./scripts/backup-test.sh
```

Verify jobs:

```bash
kubectl get jobs -n leveldb-nodeapp-poc
```

---

## 12. Trigger Restore

Make restore script executable:

```bash
chmod +x scripts/restore-test.sh
```

Run restore:

```bash
./scripts/restore-test.sh
```

Restart StatefulSet:

```bash
kubectl rollout restart statefulset leveldb-app \
-n leveldb-nodeapp-poc
```

Validate restored data:

```bash
curl localhost:3000/read
```

Expected:

```text
hello-leveldb
```