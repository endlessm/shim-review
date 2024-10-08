This repo is for review of requests for signing shim. To create a request for review:

- clone this repo (preferably fork it)
- edit the template below
- add the shim.efi to be signed
- add build logs
- add any additional binaries/certificates/SHA256 hashes that may be needed
- commit all of that
- tag it with a tag of the form "myorg-shim-arch-YYYYMMDD"
- push it to GitHub
- file an issue at https://github.com/rhboot/shim-review/issues with a link to your tag
- approval is ready when the "accepted" label is added to your issue

Note that we really only have experience with using GRUB2 or systemd-boot on Linux, so
asking us to endorse anything else for signing is going to require some convincing on
your part.

Hint: check the [docs](./docs/) directory in this repo for guidance on submission and getting your shim signed.

Here's the template:

*******************************************************************************
### What organization or people are asking to have this signed?
*******************************************************************************

Endless OS Foundation LLC
https://endlessos.org/

*******************************************************************************
### What product or service is this for?
*******************************************************************************

Endless OS.

*******************************************************************************
### What's the justification that this really does need to be signed for the whole world to be able to boot it?
*******************************************************************************

Endless OS is a Linux distribution available for anyone to download on
https://endlessos.com/download/ and also shipped with computers sold directly
by us and by our OEM partners like Asus and Acer.

*******************************************************************************
### Why are you unable to reuse shim from another distro that is already signed?
*******************************************************************************

We have a small amount of downstream patches to grub and linux. Since we can't
reuse those from another distro, we need our own shim that includes our own
vendor certificate.

*******************************************************************************
### Who is the primary contact for security updates, etc.?
The security contacts need to be verified before the shim can be accepted. For subsequent requests, contact verification is only necessary if the security contacts or their PGP keys have changed since the last successful verification.

An authorized reviewer will initiate contact verification by sending each security contact a PGP-encrypted email containing random words.
You will be asked to post the contents of these mails in your `shim-review` issue to prove ownership of the email addresses and PGP keys.
*******************************************************************************

- Name: Robert McQueen
- Position: CEO
- Email address: ramcq@endlessos.org
- PGP key fingerprint: `F864269C9010B282EE51BD607F94998DE06F63B5`

*******************************************************************************
### Who is the secondary contact for security updates, etc.?
*******************************************************************************

- Name: Will Thompson
- Position: Director of OS
- Email address: wjt@endlessos.org
- PGP key fingerprint: `1E68E58CF255888301645B563422DC0D7AD482A7`

*******************************************************************************
### Were these binaries created from the 15.8 shim release tar?
Please create your shim binaries starting with the 15.8 shim release tar file: https://github.com/rhboot/shim/releases/download/15.8/shim-15.8.tar.bz2

This matches https://github.com/rhboot/shim/releases/tag/15.8 and contains the appropriate gnu-efi source.

Make sure the tarball is correct by verifying your download's checksum with the following ones:

```
a9452c2e6fafe4e1b87ab2e1cac9ec00  shim-15.8.tar.bz2
cdec924ca437a4509dcb178396996ddf92c11183  shim-15.8.tar.bz2
a79f0a9b89f3681ab384865b1a46ab3f79d88b11b4ca59aa040ab03fffae80a9  shim-15.8.tar.bz2
30b3390ae935121ea6fe728d8f59d37ded7b918ad81bea06e213464298b4bdabbca881b30817965bd397facc596db1ad0b8462a84c87896ce6c1204b19371cd1  shim-15.8.tar.bz2
```

Make sure that you've verified that your build process uses that file as a source of truth (excluding external patches) and its checksum matches. Furthermore, there's [a detached signature as well](https://github.com/rhboot/shim/releases/download/15.8/shim-15.8.tar.bz2.asc) - check with the public key that has the fingerprint `8107B101A432AAC9FE8E547CA348D61BC2713E9F` that the tarball is authentic. Once you're sure, please confirm this here with a simple *yes*.

A short guide on verifying public keys and signatures should be available in the [docs](./docs/) directory.
*******************************************************************************

Yes, the shim binary was created from the shim-15.8.tar.bz2 tarball.

*******************************************************************************
### URL for a repo that contains the exact code which was built to result in your binary:
Hint: If you attach all the patches and modifications that are being used to your application, you can point to the URL of your application here (*`https://github.com/YOUR_ORGANIZATION/shim-review`*).

You can also point to your custom git servers, where the code is hosted.
*******************************************************************************

https://github.com/endlessm/shim/, branch `endlessm/master`, tag
`endless/15.8-1_deb12u1endless2`. This is used to create a Debian source
package with the shim tarball generated from the `pristine-tar` branch.

*******************************************************************************
### What patches are being applied and why:
Mention all the external patches and build process modifications, which are used during your building process, that make your shim binary be the exact one that you posted as part of this application.
*******************************************************************************

We have applied 2 patches:

* [0001-sbat-Add-grub.peimage-2-to-latest-CVE-2024-2312.patch](https://github.com/endlessm/shim/blob/endless/15.8-1_deb12u1endless2/debian/patches/0001-sbat-Add-grub.peimage-2-to-latest-CVE-2024-2312.patch)
* [0002-sbat-Also-bump-latest-for-grub-4-and-to-todays-date.patch](https://github.com/endlessm/shim/blob/endless/15.8-1_deb12u1endless2/debian/patches/0002-sbat-Also-bump-latest-for-grub-4-and-to-todays-date.patch)

These are backports from upstream added by Debian to provide newer SBAT
policies in shim.

*******************************************************************************
### Do you have the NX bit set in your shim? If so, is your entire boot stack NX-compatible and what testing have you done to ensure such compatibility?

See https://techcommunity.microsoft.com/t5/hardware-dev-center/nx-exception-for-shim-community/ba-p/3976522 for more details on the signing of shim without NX bit.
*******************************************************************************

No. Our grub is not NX-compatible, so we have followed the upstream default of
having the NX bit unset for shim.

*******************************************************************************
### What exact implementation of Secure Boot in GRUB2 do you have? (Either Upstream GRUB2 shim_lock verifier or Downstream RHEL/Fedora/Debian/Canonical-like implementation)
Skip this, if you're not using GRUB2.
*******************************************************************************

Downstream implementation from Debian.

*******************************************************************************
### Do you have fixes for all the following GRUB2 CVEs applied?
**Skip this, if you're not using GRUB2, otherwise make sure these are present and confirm with _yes_.**

* 2020 July - BootHole
  * Details: https://lists.gnu.org/archive/html/grub-devel/2020-07/msg00034.html
  * CVE-2020-10713
  * CVE-2020-14308
  * CVE-2020-14309
  * CVE-2020-14310
  * CVE-2020-14311
  * CVE-2020-15705
  * CVE-2020-15706
  * CVE-2020-15707
* March 2021
  * Details: https://lists.gnu.org/archive/html/grub-devel/2021-03/msg00007.html
  * CVE-2020-14372
  * CVE-2020-25632
  * CVE-2020-25647
  * CVE-2020-27749
  * CVE-2020-27779
  * CVE-2021-3418 (if you are shipping the shim_lock module)
  * CVE-2021-20225
  * CVE-2021-20233
* June 2022
  * Details: https://lists.gnu.org/archive/html/grub-devel/2022-06/msg00035.html, SBAT increase to 2
  * CVE-2021-3695
  * CVE-2021-3696
  * CVE-2021-3697
  * CVE-2022-28733
  * CVE-2022-28734
  * CVE-2022-28735
  * CVE-2022-28736
  * CVE-2022-28737
* November 2022
  * Details: https://lists.gnu.org/archive/html/grub-devel/2022-11/msg00059.html, SBAT increase to 3
  * CVE-2022-2601
  * CVE-2022-3775
* October 2023 - NTFS vulnerabilities
  * Details: https://lists.gnu.org/archive/html/grub-devel/2023-10/msg00028.html, SBAT increase to 4
  * CVE-2023-4693
  * CVE-2023-4692
*******************************************************************************

Our GRUB2 is based on Debian's GRUB2 `2.06-13+deb12u1` release, where all CVEs
from the list above were fixed.

*******************************************************************************
### If shim is loading GRUB2 bootloader, and if these fixes have been applied, is the upstream global SBAT generation in your GRUB2 binary set to 4?
Skip this, if you're not using GRUB2, otherwise do you have an entry in your GRUB2 binary similar to:  
`grub,4,Free Software Foundation,grub,GRUB_UPSTREAM_VERSION,https://www.gnu.org/software/grub/`?
*******************************************************************************

Yes. The full GRUB2 SBAT section is:

```
sbat,1,SBAT Version,sbat,1,https://github.com/rhboot/shim/blob/main/SBAT.md
grub,4,Free Software Foundation,grub,2.06,https://www.gnu.org/software/grub/
grub.debian,4,Debian,grub2,2.06-13+deb12u1,https://tracker.debian.org/pkg/grub2
grub.endless,4,Endless OS Foundation LLC,grub2,2.06+dev154.22484f8-7bem1,https://github.com/endlessm/grub
```

*******************************************************************************
### Were old shims hashes provided to Microsoft for verification and to be added to future DBX updates?
### Does your new chain of trust disallow booting old GRUB2 builds affected by the CVEs?
If you had no previous signed shim, say so here. Otherwise a simple _yes_ will do.
*******************************************************************************
- Yes, old shim hashes were provided to Microsoft.
- Yes, the new chain of trust disallows booting all previous GRUB2 and kernel
  binaries signed with our old key.

*******************************************************************************
### If your boot chain of trust includes a Linux kernel:
### Is upstream commit [1957a85b0032a81e6482ca4aab883643b8dae06e "efi: Restrict efivar_ssdt_load when the kernel is locked down"](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=1957a85b0032a81e6482ca4aab883643b8dae06e) applied?
### Is upstream commit [75b0cea7bf307f362057cc778efe89af4c615354 "ACPI: configfs: Disallow loading ACPI tables when locked down"](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=75b0cea7bf307f362057cc778efe89af4c615354) applied?
### Is upstream commit [eadb2f47a3ced5c64b23b90fd2a3463f63726066 "lockdown: also lock down previous kgdb use"](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=eadb2f47a3ced5c64b23b90fd2a3463f63726066) applied?
Hint: upstream kernels should have all these applied, but if you ship your own heavily-modified older kernel version, that is being maintained separately from upstream, this may not be the case.  
If you are shipping an older kernel, double-check your sources; maybe you do not have all the patches, but ship a configuration, that does not expose the issue(s).
*******************************************************************************

Yes, our most recent kernel is based on an upstrem release that already
includes these commits:

https://github.com/endlessm/linux/commit/1957a85b0032
https://github.com/endlessm/linux/commit/75b0cea7bf30
https://github.com/endlessm/linux/commit/eadb2f47a3ce

*******************************************************************************
### Do you build your signed kernel with additional local patches? What do they do?
*******************************************************************************

Our kernel is based on Ubuntu's 6.5.0-10.10 release. For both Endless and
Ubuntu, the downstream patches are primarily security fixes and upstream
backports for hardware issues reported by partners and users.

Endless also includes a small custom LSM (`endlesspayg`), but it is only used
on systems that do not use shim for booting.

*******************************************************************************
### Do you use an ephemeral key for signing kernel modules?
### If not, please describe how you ensure that one kernel build does not load modules built for another kernel.
*******************************************************************************

Yes.

*******************************************************************************
### If you use vendor_db functionality of providing multiple certificates and/or hashes please briefly describe your certificate setup.
### If there are allow-listed hashes please provide exact binaries for which hashes are created via file sharing service, available in public with anonymous access for verification.
*******************************************************************************

We do not use the vendor_db functionality.

*******************************************************************************
### If you are re-using the CA certificate from your last shim binary, you will need to add the hashes of the previous GRUB2 binaries exposed to the CVEs mentioned earlier to vendor_dbx in shim. Please describe your strategy.
This ensures that your new shim+GRUB2 can no longer chainload those older GRUB2 binaries with issues.

If this is your first application or you're using a new CA certificate, please say so here.
*******************************************************************************

Rather than revoke individual binary hashes, the signing certificate we used to
sign GRUB2 and the linux kernel image has been replaced. That and all previous
signing certificates were added to the new shim's vendor_dbx.

*******************************************************************************
### Is the Dockerfile in your repository the recipe for reproducing the building of your shim binary?
A reviewer should always be able to run `docker build .` to get the exact binary you attached in your application.

Hint: Prefer using *frozen* packages for your toolchain, since an update to GCC, binutils, gnu-efi may result in building a shim binary with a different checksum.

If your shim binaries can't be reproduced using the provided Dockerfile, please explain why that's the case, what the differences would be and what build environment (OS and toolchain) is being used to reproduce this build? In this case please write a detailed guide, how to setup this build environment from scratch.
*******************************************************************************

Yes, the `Dockerfile` provided here can fully reproduce the shim binary by
running `docker build .`. The build environment is frozen using an image
created using `Dockerfile-buildroot` at the time shim was built. It has been
published to the GitHub container registry. For convenience, the `build.sh`
script will run the docker build and extract `shimx64.efi` for analysis.

*******************************************************************************
### Which files in this repo are the logs for your build?
This should include logs for creating the buildroots, applying patches, doing the build, creating the archives, etc.
*******************************************************************************

[buildlog.txt](buildlog.txt) contains the log for the exact build of shim
provided here using Open Build Service (OBS). It shows all steps of creating
the buildroot and running the Debian binary package build. The package build
contains all the steps beyond creating the buildroot.

*******************************************************************************
### What changes were made in the distro's secure boot chain since your SHIM was last signed?
For example, signing new kernel's variants, UKI, systemd-boot, new certs, new CA, etc..

Skip this, if this is your first application for having shim signed.
*******************************************************************************

Since our last signature in 2021 there have been no new assets in our boot
chain.

Our CA certificate was nearing it's 10 year expiration, so we reissued it in
2022 with a 30 year expiration period. The Subject and Public Key are retained
so that existing signatures remain valid. The certificate is otherwise
identical except that the deprecated Netscape Certificate Type field has been
removed. New signing certificates were also issued from the CA.

*******************************************************************************
### What is the SHA256 hash of your final shim binary?
*******************************************************************************

`7859e02e1fc6dff8e2b221dfcbfaffcb6d1e95e2acb65403e5db7c849f9221cd`

*******************************************************************************
### How do you manage and protect the keys used in your shim?
Describe the security strategy that is used for key protection. This can range from using hardware tokens like HSMs or Smartcards, air-gapped vaults, physical safes to other good practices.
*******************************************************************************

We have generated our own secure boot CA private key which is stored offline
with physical security protection and only accessed to provision new signing
keys. The CA public key is the one embedded in the shim binary. The signing
keys which are used in our build servers to sign the bootloader and kernel are
stored in J3A081 80K smartcard HW encryption devices. This is based on the
procedure described
[here](https://fedoraproject.org/wiki/User:Pjones/SecureBootSmartCardDeployment).

*******************************************************************************
### Do you use EV certificates as embedded certificates in the shim?
A _yes_ or _no_ will do. There's no penalty for the latter.
*******************************************************************************

No.

*******************************************************************************
### Do you add a vendor-specific SBAT entry to the SBAT section in each binary that supports SBAT metadata ( GRUB2, fwupd, fwupdate, systemd-boot, systemd-stub, shim + all child shim binaries )?
### Please provide the exact SBAT entries for all binaries you are booting directly through shim.
Hint: The history of SBAT and more information on how it works can be found [here](https://github.com/rhboot/shim/blob/main/SBAT.md). That document is large, so for just some examples check out [SBAT.example.md](https://github.com/rhboot/shim/blob/main/SBAT.example.md)

If you are using a downstream implementation of GRUB2 (e.g. from Fedora or Debian), make sure you have their SBAT entries preserved and that you **append** your own (don't replace theirs) to simplify revocation.

**Remember to post the entries of all the binaries. Apart from your bootloader, you may also be shipping e.g. a firmware updater, which will also have these.**

Hint: run `objcopy --only-section .sbat -O binary YOUR_EFI_BINARY /dev/stdout` to get these entries. Paste them here. Preferably surround each listing with three backticks (\`\`\`), so they render well.
*******************************************************************************

Currently only GRUB2 is booted directly by shim. All of these have SBAT
entries.

Shim (`shimx64.efi`), MokManager (`mmx64.efi`), Fallback (`fbx64.efi`):
```
sbat,1,SBAT Version,sbat,1,https://github.com/rhboot/shim/blob/main/SBAT.md
shim,4,UEFI shim,shim,1,https://github.com/rhboot/shim
shim.endless,1,Endless OS Foundation LLC,shim,15.8,https://github.com/endlessm/shim
```

GRUB2 (`grubx64.efi`):
```
sbat,1,SBAT Version,sbat,1,https://github.com/rhboot/shim/blob/main/SBAT.md
grub,4,Free Software Foundation,grub,2.06,https://www.gnu.org/software/grub/
grub.debian,4,Debian,grub2,2.06-13+deb12u1,https://tracker.debian.org/pkg/grub2
grub.endless,4,Endless OS Foundation LLC,grub2,2.06+dev154.22484f8-7bem1,https://github.com/endlessm/grub
```

*******************************************************************************
### If shim is loading GRUB2 bootloader, which modules are built into your signed GRUB2 image?
Skip this, if you're not using GRUB2.

Hint: this is about those modules that are in the binary itself, not the `.mod` files in your filesystem.
*******************************************************************************

To simplify distribution, all modules are built into `grubx64.efi`:

```
all_video
blscfg
boot
btrfs
cat
chain
configfile
disk
echo
efifwsetup
efinet
ext2
exfat
fat
file
font
gcry_sha512
gcry_rsa
gettext
gfxmenu
gfxterm
gfxterm_background
gzio
halt
hfsplus
iso9660
jpeg
keystatus
loadenv
loopback
linux
linuxefi
ls
lsefi
lsefimmap
lsefisystab
lssal
memdisk
minicmd
normal
ntfs
part_apple
part_msdos
part_gpt
password_pbkdf2
png
pgp
probe
read
reboot
regexp
search
search_fs_uuid
search_fs_file
search_label
search_fs_type
sleep
squash4
test
time
true
video
```

*******************************************************************************
### If you are using systemd-boot on arm64 or riscv, is the fix for [unverified Devicetree Blob loading](https://github.com/systemd/systemd/security/advisories/GHSA-6m6p-rjcq-334c) included?
*******************************************************************************

We are not using systemd-boot on those platforms.

*******************************************************************************
### What is the origin and full version number of your bootloader (GRUB2 or systemd-boot or other)?
*******************************************************************************

Our GRUB2 full version is `2.06+dev154.22484f8-7bem1` and comes from the
https://github.com/endlessm/grub repo. This uses branches `master` (for code)
and `debian-master` (for packaging).

This version is based on Debian's `2.06-13+deb12u1` release, which is based on
the `2.06` upstream release.

The full set of patches relative to 2.06 can be viewed at
https://github.com/endlessm/grub/compare/grub-2.06...Release_6.0.2 The commits
with `[DEB]` prefix come from Debian's `2.06-13+deb12u1` release. All other
commits are Endless specific.

*******************************************************************************
### If your shim launches any other components apart from your bootloader, please provide further details on what is launched.
Hint: The most common case here will be a firmware updater like fwupd.
*******************************************************************************

Currently our shim does not launch any other components.

*******************************************************************************
### If your GRUB2 or systemd-boot launches any other binaries that are not the Linux kernel in SecureBoot mode, please provide further details on what is launched and how it enforces Secureboot lockdown.
Skip this, if you're not using GRUB2 or systemd-boot.
*******************************************************************************

Currently our shim does not launch any other components.

*******************************************************************************
### How do the launched components prevent execution of unauthenticated code?
Summarize in one or two sentences, how your secure bootchain works on higher level.
*******************************************************************************

Only GRUB2's `linuxefi` loader is run. This uses the shim lock protocol to
verify the kernel in secure boot.

*******************************************************************************
### Does your shim load any loaders that support loading unsigned kernels (e.g. certain GRUB2 configurations)?
*******************************************************************************

No, the GRUB version we ship does not allow loading unsigned kernels under
secure boot. The `linux` loader in our grub EFI binary always hands-off loading
to the `linuxefi` module, which verifies the kernel via the shim protocol under
secure boot.

*******************************************************************************
### What kernel are you using? Which patches and configuration does it include to enforce Secure Boot?
*******************************************************************************

We are currently based on Linux 6.5 using Ubuntu's `6.5.0-10.10` release. It is
configured with `CONFIG_INTEGRITY`, `CONFIG_INTEGRITY_PLATFORM_KEYRING` and
`CONFIG_INTEGRITY_MACHINE_KEYRING` so that the integrity ISA subsystem is
enabled and loads secure boot and MOK certificates to verify external kernel
modules.

Additionally, it contains RedHat's lockdown patches via Ubuntu with
`CONFIG_LOCK_DOWN_IN_EFI_SECURE_BOOT` enabled so that only signed kernel
modules can be loaded when secure boot is enabled.

*******************************************************************************
### What contributions have you made to help us review the applications of other applicants?
The reviewing process is meant to be a peer-review effort and the best way to have your application reviewed faster is to help with reviewing others. We are in most cases volunteers working on this venue in our free time, rather than being employed and paid to review the applications during our business hours. 

A reasonable timeframe of waiting for a review can reach 2-3 months. Helping us is the best way to shorten this period. The more help we get, the faster and the smoother things will go.

For newcomers, the applications labeled as [*easy to review*](https://github.com/rhboot/shim-review/issues?q=is%3Aopen+is%3Aissue+label%3A%22easy+to+review%22) are recommended to start the contribution process.
*******************************************************************************

I (@dbnicholson) was not aware of this effort but will try to help some
reviews.

*******************************************************************************
### Add any additional information you think we may need to validate this shim signing application.
*******************************************************************************

Shim is built with `SBAT_AUTOMATIC_DATE=2024010900` with the following
`.sbatlevel` policy:

```
7sbat,1,2024010900
shim,4
grub,3
grub.debian,4
sbat,1,2024040900
shim,4
grub,4
grub.peimage,2
```
