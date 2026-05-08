#!/bin/bash

# Creates an LVM snapshot of the active LevelDB volume and performs
# an incremental Restic backup to remote object storage.

set -e

VG_NAME="lvmvg1"

LV_NAME="pvc-volume"

SNAP_NAME="leveldb-snap"

SNAP_SIZE="20G"

SNAP_PATH="/dev/${VG_NAME}/${SNAP_NAME}"

MOUNT_PATH="/mnt/leveldb-snapshot"

# Remote backup repository
export RESTIC_REPOSITORY="s3:http://minio:9000/backups"

# Example credentials
# In production these should come from Kubernetes Secrets
export AWS_ACCESS_KEY_ID="minioadmin"

export AWS_SECRET_ACCESS_KEY="minioadmin"

echo "Creating LVM snapshot..."

lvcreate --snapshot \
--size ${SNAP_SIZE} \
--name ${SNAP_NAME} \
/dev/${VG_NAME}/${LV_NAME}

echo "Creating snapshot mount directory..."

mkdir -p ${MOUNT_PATH}

echo "Mounting snapshot..."

mount ${SNAP_PATH} ${MOUNT_PATH}

echo "Initializing Restic repository if needed..."

restic snapshots || restic init

echo "Running incremental Restic backup..."

restic backup ${MOUNT_PATH}

echo "Unmounting snapshot..."

umount ${MOUNT_PATH}

echo "Removing snapshot..."

lvremove -f ${SNAP_PATH}

echo "Backup completed successfully."   