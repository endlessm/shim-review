FROM debian:bullseye
ARG PKGVER="15.4+dev8.ab30a4a"
ADD --chown=root:root endless.origins /etc/dpkg/origins/endless
RUN apt update -y
RUN DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends build-essential devscripts git
RUN git clone --recurse-submodules https://github.com/endlessm/shim.git shim-${PKGVER}
WORKDIR /shim-${PKGVER}
RUN git config user.email "root@example.com"
RUN git merge --allow-unrelated-histories -m "Import the packaging bits into master" origin/debian-master
RUN echo "1.0" > debian/source/format
RUN echo "--compression=gzip" > debian/source/options
RUN apt build-dep -y .
ENV DEBEMAIL="root@example.com"
RUN dch -v ${PKGVER} -D eos --force-distribution "Automatic release from git (${PKGVER})"
RUN rm -rf .git
RUN DEB_VENDOR=endless dpkg-buildpackage -us -uc
WORKDIR /
RUN dpkg-deb -x shim-efi-image_${PKGVER}_amd64.deb shim-efi-image
RUN cp shim-efi-image/boot/efi/EFI/endless/shimx64.efi .
RUN sha256sum shimx64.efi
