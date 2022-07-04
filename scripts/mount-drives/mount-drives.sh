#!/usr/bin/env bash

function onedrive() {
  sh -c "rclone --vfs-cache-mode writes mount onedriveuib: ~/'OneDrive - University of Bergen'" &
}

function googledrive() {
  sh -c "rclone --vfs-cache-mode writes mount google: ~/'Google Drive'" &
}

googledrive

notify-send "Drives mounted"
