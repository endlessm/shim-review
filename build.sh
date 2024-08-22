#!/bin/bash -e

srcdir=$(realpath "$(dirname "$0")")
builddir="$srcdir/build"

: ${DOCKER:=docker}

$DOCKER build --no-cache -t endless-shim-review .

rm -rf "$builddir"
mkdir -p "$builddir"
id=$($DOCKER create endless-shim-review)
$DOCKER cp "$id:/shim/shimx64.efi" "$builddir/"
$DOCKER cp "$id:/shim/shimx64.efi.hd" "$builddir/"
$DOCKER rm -v "$id"

echo "Review shim: $srcdir/shimx64.efi"
echo "Build shim: $builddir/shimx64.efi"
