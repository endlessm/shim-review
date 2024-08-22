The submitted shim can be reproduced using the [Dockerfile](Dockerfile) by
running `docker build .`. As a convenience, [build.sh](build.sh) can be run to
create the build image and extract `shimx64.efi` for inspection. When the
script completes, the built shim can be found in `build/shimx64.efi`.
