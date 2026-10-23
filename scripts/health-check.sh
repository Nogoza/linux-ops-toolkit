#!/usr/bin/env bash

if [ "$#" -gt 1 ]; then
    echo "ERROR: En fazla bir eşik argümanı verilebilir." >&2
    exit 2
fi

threshold="${1-80}"

if [[ ! "$threshold" =~ ^([1-9][0-9]?|100)$ ]]; then
    echo "ERROR: Eşik 1–100 arasında bir tam sayı olmalıdır." >&2
    exit 2
fi

disk_usage=$(df -P / | awk 'NR == 2 {gsub(/%/, "", $5); print $5}')

if [ "$disk_usage" -ge "$threshold" ]; then
    echo "WARNING: Disk kullanımı %$disk_usage — eşik %$threshold"
    exit 1
else
    echo "OK: Disk kullanımı %$disk_usage — eşik %$threshold"
    exit 0
fi
