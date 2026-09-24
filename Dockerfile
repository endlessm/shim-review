# This is for rebuilding shim to compare to the submitted shim. It uses
# the buildroot image which hopefully provides a build environment
# identical to the one used to build the original shim.

ARG IMAGE_REPO=ghcr.io/endlessm/shim-review-buildroot
ARG IMAGE_TAG=endless-shim-x64-20260924
FROM ${IMAGE_REPO}:${IMAGE_TAG}

COPY . /shim-review

ARG GIT_TAG=endless/16.1-2_deb12u1endless1
ARG PKG_VERSION=16.1-2~deb12u1endless1
ARG UPSTREAM_VERSION=16.1
ARG UPSTREAM_TARBALL_SHA256=46319cd228d8f2c06c744241c0f342412329a7c630436fce7f82cf6936b1d603

# The endlessm/shim pristine-tar branch doesn't have data for every upstream
# release, so fetch the orig tarball directly into the
# --git-export-dir gbp buildpackage uses below; gbp picks it up from there
# instead of trying to regenerate it via pristine-tar.
RUN mkdir -p /shim-build && \
    curl -fsSL -o "/shim-build/shim_${UPSTREAM_VERSION}.orig.tar.bz2" \
      "https://github.com/rhboot/shim/releases/download/${UPSTREAM_VERSION}/shim-${UPSTREAM_VERSION}.tar.bz2" && \
    echo "${UPSTREAM_TARBALL_SHA256}  /shim-build/shim_${UPSTREAM_VERSION}.orig.tar.bz2" | sha256sum -c

RUN gbp clone --pristine-tar https://github.com/endlessm/shim.git && \
    cd /shim && \
    git checkout -B endless/master "${GIT_TAG}" && \
    export DEB_BUILD_OPTIONS=nocheck && \
    gbp buildpackage --git-builder=dpkg-buildpackage --git-export-dir=/shim-build --git-no-pristine-tar && \
    dpkg-deb -x /shim-build/shim-efi-image_*.deb /shim-build/shim-efi-image && \
    cp /shim-build/shim-efi-image/boot/efi/EFI/endless/shimx64.efi /shim-build && \
    rm -rf /shim-build/shim-efi-image && \
    hexdump -Cv /shim-build/shimx64.efi > /shim-build/shimx64.efi.hd

RUN echo "${UPSTREAM_TARBALL_SHA256}  /shim-build/shim_${UPSTREAM_VERSION}.orig.tar.bz2" | sha256sum -c && \
    sha256sum /shim-review/shimx64.efi && \
    sha256sum /shim-build/shimx64.efi && \
    if cmp -s /shim-review/shimx64.efi /shim-build/shimx64.efi; then \
    echo "Built shim matches review shim"; \
    else \
    echo "ERROR: Built shim does not match review shim!" && \
    diff -u /shim-review/shimx64.efi.hd /shim-build/shimx64.efi.hd || \
    true; \
    fi
