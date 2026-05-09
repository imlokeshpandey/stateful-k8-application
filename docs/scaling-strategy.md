# Scaling Strategy

The current PoC uses Vertical Pod Autoscaler (VPA) based scaling with a single StatefulSet replica.

This approach was chosen because the application uses embedded LevelDB storage, where multiple active replicas could lead to data inconsistency and storage synchronization issues.

Instead of horizontal replica scaling, Kubernetes can automatically scale CPU and memory resources for the existing pod based on workload usage.

Example:

```text
CPU: 2 → 4
Memory: 4Gi → 8Gi
```

The architecture also supports PVC expansion for increasing storage capacity when dataset size grows.