#!/usr/bin/env bash
health_script="${1:-scripts/health-check.sh}"

output=$(
    df() {
        echo "TEST: disk ölçümü başarısız oldu." >&2
        return 1
    }

    export -f df
	bash "$health_script" 80 2>&1

)
result=$?

if [ "$result" -ne 3 ]; then
    printf 'FAIL: Beklenen kod 3, gelen: %s\n%s\n' \
        "$result" "$output" >&2
    exit 1
fi

if [[ "$output" == *"OK:"* || "$output" == *"WARNING:"* ]]; then
    printf 'FAIL: Ölçüm hatasında eşik sonucu yazdırıldı.\n%s\n' \
        "$output" >&2
    exit 1
fi

echo "PASS: disk hatası kod 3 döndürüyor ve eşik sonucu yazdırmıyor."

# Bellek ölçüm hatası testi
output=$(
    free() {
        echo "TEST: Bellek ölçümü başarısız oldu." >&2
        return 1
    }

    export -f free

    bash "$health_script" 80 2>&1
)
result=$?

if [ "$result" -ne 3 ]; then
    printf 'FAIL: Bellek testi kod 3 bekliyordu, gelen: %s\n%s\n' \
        "$result" "$output" >&2
    exit 1
fi

if [[ "$output" == *"OK:"* || "$output" == *"WARNING:"* ]]; then
    printf 'FAIL: Bellek hatasında eşik sonucu yazdırıldı.\n%s\n' \
        "$output" >&2
    exit 1
fi

echo "PASS: Bellek hatası kod 3 döndürüyor ve eşik sonucu yazdırmıyor."
