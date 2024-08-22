# This is for rebuilding shim to compare to the submitted shim. It uses
# the buildroot image which hopefully provides a build environment
# identical to the one used to build the original shim.

ARG IMAGE_REPO=ghcr.io/endlessm/shim-review-buildroot
ARG IMAGE_TAG=endless-shim-x64-20240822
FROM ${IMAGE_REPO}:${IMAGE_TAG}

COPY . /shim-review

ARG GIT_TAG=endless/15.8-1_deb12u1endless1
ARG PKG_VERSION=15.8-1~deb12u1endless1
RUN gbp clone --pristine-tar https://github.com/endlessm/shim.git && \
    cd /shim && \
    git checkout -B endless/master "${GIT_TAG}" && \
    export DEB_BUILD_OPTIONS=nocheck && \
    gbp buildpackage --git-builder=dpkg-buildpackage && \
    cp debian/shim-efi-image/boot/efi/EFI/endless/shimx64.efi /shim && \
    hexdump -Cv /shim/shimx64.efi > /shim/shimx64.efi.hd

RUN sha256sum /shim-review/shimx64.efi && \
    sha256sum /shim/shimx64.efi && \
    if cmp -s /shim-review/shimx64.efi /shim/shimx64.efi; then \
    echo "Built shim matches review shim"; \
    else \
    echo "ERROR: Built shim does not match review shim!" && \
    diff -u /shim-review/shimx64.efi.hd /shim/shimx64.efi.hd || \
    true; \
    fi
