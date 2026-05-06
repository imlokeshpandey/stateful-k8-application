# stateful-k8-application
1. Overview

This proof-of-concept demonstrates how to deploy and operate a stateful LevelDB-based application on Kubernetes with:

Persistent and resilient storage
Automatic recovery from pod/node failures
Snapshot-based backup and restore using LVM + Restic
Monitoring, alerting, and observability
Production-oriented migration and scaling strategy

The application stores approximately 2 TB of persistent data per pod and requires an RPO (Recovery Point Objective) of 6 hours.
