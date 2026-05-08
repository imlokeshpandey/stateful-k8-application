# Scaling Strategy

## Current Scaling Model

The application uses embedded LevelDB storage mounted through Kubernetes PersistentVolumeClaims backed by OpenEBS LocalPV-LVM.

Because LevelDB is a single-node embedded database, the architecture prioritizes:

- consistency,
- low-latency local storage,
- and storage reliability

over horizontal multi-replica scaling.

---

# Recommended Scaling Approaches

## 1. Vertical Scaling (Primary Recommendation)

The preferred scaling strategy is vertical scaling.

LevelDB performance benefits heavily from:

- additional memory,
- filesystem cache,
- CPU throughput,
- and NVMe SSD performance.

Example Kubernetes resource allocation:

```yaml
resources:
  requests:
    cpu: "4"
    memory: "8Gi"

  limits:
    cpu: "8"
    memory: "16Gi"
```

---

## 2. Vertical Pod Autoscaler (VPA)

Vertical Pod Autoscaler can automatically recommend or adjust:

- CPU
- memory

for the Stateful workload based on utilization patterns.

This is safer than Horizontal Pod Autoscaling for embedded stateful databases.

---

## 3. PVC Capacity Expansion

The OpenEBS LVM StorageClass supports online volume expansion.

Example:

```text
2 TB → 4 TB
```

This allows dataset growth without redesigning the application architecture.

---

## 4. Node-Level Scaling

Additional worker nodes can be introduced to provide:

- larger storage pools,
- additional NVMe capacity,
- and future sharding opportunities.

---

# Horizontal Scaling Limitations

Horizontal Pod Autoscaling with multiple active replicas is not recommended for the current architecture because each StatefulSet replica would maintain independent LevelDB state.

This could lead to:

- inconsistent datasets,
- split-brain behavior,
- and application-level conflicts.