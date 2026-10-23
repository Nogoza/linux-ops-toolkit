#!/usr/bin/env bash
set -o pipefail

if [ "$#" -gt 1 ]; then
    echo "ERROR: En fazla bir eşik argümanı verilebilir." >&2
    exit 2
fi

threshold="${1-80}"

if [[ ! "$threshold" =~ ^([1-9][0-9]?|100)$ ]]; then
    echo "ERROR: Eşik 1–100 arasında bir tam sayı olmalıdır." >&2
    exit 2
fi

echo "Time: $(date -Iseconds)"
echo "Host: $(hostname)"

if ! memory_report=$(free -m | awk '/^Mem:/ {
    printf "Memory (MiB): total=%s used=%s available=%s\n", $2, $3, $7
}'); then
    echo "ERROR: Bellek bilgisi alınamadı." >&2
    exit 3
fi

echo "$memory_report"
if ! disk_usage=$(df -P / | awk 'NR == 2 {gsub(/%/, "", $5); print $5}'); then
	printf "ERROR: Disk bilgisi alınamadı. \n" >&2
	exit 3
fi

if [ "$disk_usage" -ge "$threshold" ]; then
    echo "WARNING: Disk kullanımı %$disk_usage — eşik %$threshold"
    exit 1
else
    echo "OK: Disk kullanımı %$disk_usage — eşik %$threshold"
    exit 0
fi
