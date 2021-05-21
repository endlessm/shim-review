#!/bin/bash -e

sudo docker build --no-cache -t endless-shim-review .

id=$(sudo docker create endless-shim-review)
sudo docker cp $id:shimx64.efi .
sudo docker rm -v $id

sha256sum -c shimx64.efi.sha256
