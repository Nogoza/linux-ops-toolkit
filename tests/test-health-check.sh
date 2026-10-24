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

# Disk kullanımı eşikten düşük
output=$(
    df() {
        printf '%s\n' \
            'Filesystem 1024-blocks Used Available Capacity Mounted on' \
            '/dev/mock 100 79 21 79% /'
    }

    export -f df

    bash "$health_script" 80 2>&1
)
result=$?

if [[ "$result" -ne 0 || "$output" != *"OK: Disk kullanımı %79"* ]]; then
    printf 'FAIL: Eşik altı testi; çıkış kodu: %s\n%s\n' \
        "$result" "$output" >&2
    exit 1
fi

echo "PASS: Disk %79, eşik %80: OK ve çıkış kodu 0."

# Disk kullanımı eşiğe eşit
output=$(
    df() {
        printf '%s\n' \
            'Filesystem 1024-blocks Used Available Capacity Mounted on' \
            '/dev/mock 100 80 20 80% /'
    }

    export -f df

    bash "$health_script" 80 2>&1
)
result=$?

if [[ "$result" -ne 1 || "$output" != *"WARNING: Disk kullanımı %80"* ]]; then
    printf 'FAIL: Eşiğe eşitlik testi; çıkış kodu: %s\n%s\n' \
        "$result" "$output" >&2
    exit 1
fi

echo "PASS: Disk %80, eşik %80: WARNING ve çıkış kodu 1."

# Disk kullanımı eşikten yüksek
output=$(
    df() {
        printf '%s\n' \
            'Filesystem 1024-blocks Used Available Capacity Mounted on' \
            '/dev/mock 100 81 19 81% /'
    }

    export -f df

    bash "$health_script" 80 2>&1
)
result=$?

if [[ "$result" -ne 1 || "$output" != *"WARNING: Disk kullanımı %81"* ]]; then
    printf 'FAIL: Eşik üstü testi; çıkış kodu: %s\n%s\n' \
        "$result" "$output" >&2
    exit 1
fi

echo "PASS: Disk %81, eşik %80: WARNING ve çıkış kodu 1."
