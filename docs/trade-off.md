# Design Trade-Offs

## Storage Architecture

The PoC uses OpenEBS LocalPV-LVM with node-local storage.

### Benefits

- low-latency local disk performance
- simpler storage architecture
- lower infrastructure overhead
- efficient LevelDB access patterns

### Trade-Offs

- storage remains tied to worker node
- no automatic cross-node PVC failover
- node recovery depends on restore workflows

---

## Scaling Strategy

The application currently uses a single StatefulSet replica because LevelDB is an embedded local database.

### Benefits

- storage consistency
- simpler operational model
- predictable recovery workflows

### Trade-Offs

- limited horizontal scaling
- no native multi-node synchronization
- scaling requires application-aware sharding or distributed database redesign

---

## Backup and Recovery

The architecture uses LVM snapshots with Restic incremental backups.

### Benefits

- reduced backup transfer overhead
- point-in-time backup consistency
- lower backup storage consumption

### Trade-Offs

- recovery depends on restore duration
- no real-time storage replication
- backup scheduling impacts achievable RPO

---

## Operational Complexity

The current PoC prioritizes operational simplicity over distributed storage complexity.

### Benefits

- easier troubleshooting
- simpler infrastructure management
- lower operational cost

### Trade-Offs

- fewer high-availability capabilities
- manual disaster recovery workflows
- reduced automatic failover behavior

---

## Performance Considerations

The architecture is optimized for local persistent storage performance.

### Benefits

- high IO throughput
- low storage latency
- efficient embedded database operations

### Trade-Offs

- storage portability limitations
- infrastructure tied to local disk availability
- distributed storage features intentionally excluded