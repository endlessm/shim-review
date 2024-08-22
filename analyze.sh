#!/bin/bash -e

shim=${1:?No shim specified to analyze}

echo "== $shim DllCharacteristics =="
objdump -p "$shim" | grep DllCharacteristics

echo "== $shim .sbat =="
objcopy --only-section .sbat -O binary "$shim" /dev/stdout

echo "== $shim .sbatlevel =="
objcopy --only-section .sbatlevel -O binary "$shim" /dev/stdout

echo "== $shim .vendor_cert =="
objcopy --only-section .vendor_cert -O binary "$shim" /dev/stdout \
    | openssl x509 -inform DER -noout -text
