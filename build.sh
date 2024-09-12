#!/bin/bash -e

srcdir=$(realpath "$(dirname "$0")")
builddir="$srcdir/build"

: ${DOCKER:=docker}

$DOCKER build --no-cache -t endless-shim-review .

rm -rf "$builddir"
id=$($DOCKER create endless-shim-review)
$DOCKER cp "$id:/shim-build/" "$builddir"
$DOCKER rm -v "$id"

echo "Review shim: $srcdir/shimx64.efi"
echo "Build shim: $builddir/shimx64.efi"
