This repo is for review of requests for signing shim.  To create a request for review:

- clone this repo
- edit the template below
- add the shim.efi to be signed
- add build logs
- add any additional binaries/certificates/SHA256 hashes that may be needed
- commit all of that
- tag it with a tag of the form "myorg-shim-arch-YYYYMMDD"
- push that to github
- file an issue at https://github.com/rhboot/shim-review/issues with a link to your branch
- approval is ready when you have accepted tag

Note that we really only have experience with using GRUB2 on Linux, so asking
us to endorse anything else for signing is going to require some convincing on
your part.

Here's the template:

-------------------------------------------------------------------------------
What organization or people are asking to have this signed:
-------------------------------------------------------------------------------
Endless OS Foundation LLC
https://endlessos.org/

-------------------------------------------------------------------------------
What product or service is this for:
-------------------------------------------------------------------------------
Endless OS.

-------------------------------------------------------------------------------
What's the justification that this really does need to be signed for the whole world to be able to boot it:
-------------------------------------------------------------------------------
Endless OS is a Linux distribution available for anyone to download on
https://endlessos.com/download/ and also shipped with computers sold directly
by us and by our OEM partners like Asus and Acer.

-------------------------------------------------------------------------------
Who is the primary contact for security updates, etc.
-------------------------------------------------------------------------------
- Name: Robert McQueen
- Position: CEO
- Email address: ramcq@endlessos.org
- PGP key, signed by the other security contacts, and preferably also with signatures that are reasonably well known in the Linux community:
  `F864269C9010B282EE51BD607F94998DE06F63B5`

-------------------------------------------------------------------------------
Who is the secondary contact for security updates, etc.
-------------------------------------------------------------------------------
- Name: Will Thompson
- Position: Director of OS
- Email address: wjt@endlessos.org
- PGP key, signed by the other security contacts, and preferably also with signatures that are reasonably well known in the Linux community:
  `1E68E58CF255888301645B563422DC0D7AD482A7`

-------------------------------------------------------------------------------
Please create your shim binaries starting with the 15.4 shim release tar file:
https://github.com/rhboot/shim/releases/download/15.4/shim-15.4.tar.bz2

This matches https://github.com/rhboot/shim/releases/tag/15.4 and contains
the appropriate gnu-efi source.
-------------------------------------------------------------------------------

Yes, we are based on upstream commit `4068fd42`, which is 4 commits on top of tag `15.4`.

-------------------------------------------------------------------------------
URL for a repo that contains the exact code which was built to get this binary:
-------------------------------------------------------------------------------
https://github.com/endlessm/shim/, branch `master`, commit hash `ab30a4af`.

-------------------------------------------------------------------------------
What patches are being applied and why:
-------------------------------------------------------------------------------
We are applying 4 patches to the fallback program. No Endless-specific patches
change the shim binary.

This set of changes have fallback treat boot entries with the same label as
duplicates, and remove any entries that are a duplicte of the entry we are
about to create from the CSV file in the fallback path. This is necessary for
Endless OS because randomize the partition ids during the first boot, since the
partition layout is created by the server at image build time and the image in
simply dd'ed to the disk during installation.

The full list of commits, starting from upstream commit `4068fd42`, can be
found below:

- `f428985b fallback: Print info on GetNextVariableName errors`
- `f5e1d7f7 fallback: Use a dynamic buffer when list var names`
- `97f57410 Revert "fallback: work around the issue of boot option creation with AMI BIOS"`
- `ab30a4af fallback: Clean-up duplicate boot entries`

-------------------------------------------------------------------------------
If bootloader, shim loading is, GRUB2: is CVE-2020-14372, CVE-2020-25632,
 CVE-2020-25647, CVE-2020-27749, CVE-2020-27779, CVE-2021-20225, CVE-2021-20233,
 CVE-2020-10713, CVE-2020-14308, CVE-2020-14309, CVE-2020-14310, CVE-2020-14311,
 CVE-2020-15705, and if you are shipping the shim_lock module CVE-2021-3418
-------------------------------------------------------------------------------
Our GRUB2 is based on Debian's GRUB2 2.04-16, where all CVEs from the list
above that affect that codebase were fixed. The shim_lock module is not used.

-------------------------------------------------------------------------------
What exact implementation of Secureboot in GRUB2 ( if this is your bootloader ) you have ?
* Upstream GRUB2 shim_lock verifier or * Downstream RHEL/Fedora/Debian/Canonical like implementation ?
-------------------------------------------------------------------------------
Downstream implementation from Debian.

-------------------------------------------------------------------------------
If bootloader, shim loading is, GRUB2, and previous shims were trusting affected
by CVE-2020-14372, CVE-2020-25632, CVE-2020-25647, CVE-2020-27749,
  CVE-2020-27779, CVE-2021-20225, CVE-2021-20233, CVE-2020-10713,
  CVE-2020-14308, CVE-2020-14309, CVE-2020-14310, CVE-2020-14311, CVE-2020-15705,
  and if you were shipping the shim_lock module CVE-2021-3418
  ( July 2020 grub2 CVE list + March 2021 grub2 CVE list )
  grub2:
* were old shims hashes provided to Microsoft for verification
  and to be added to future DBX update ?
* Does your new chain of trust disallow booting old, affected by CVE-2020-14372,
  CVE-2020-25632, CVE-2020-25647, CVE-2020-27749,
  CVE-2020-27779, CVE-2021-20225, CVE-2021-20233, CVE-2020-10713,
  CVE-2020-14308, CVE-2020-14309, CVE-2020-14310, CVE-2020-14311, CVE-2020-15705,
  and if you were shipping the shim_lock module CVE-2021-3418
  ( July 2020 grub2 CVE list + March 2021 grub2 CVE list )
  grub2 builds ?
-------------------------------------------------------------------------------
- Yes, old shim hashes were provided to Microsoft.
- Yes, the new chain of trust disallow booting all previous GRUB2 and kernel
  binaries signed with our old key.

-------------------------------------------------------------------------------
If your boot chain of trust includes linux kernel, is
"efi: Restrict efivar_ssdt_load when the kernel is locked down"
upstream commit 1957a85b0032a81e6482ca4aab883643b8dae06e applied ?
Is "ACPI: configfs: Disallow loading ACPI tables when locked down"
upstream commit 75b0cea7bf307f362057cc778efe89af4c615354 applied ?
-------------------------------------------------------------------------------
Yes, our most recent kernel is based on an upstrem release that already includes
these commits:
https://github.com/endlessm/linux/commit/1957a85b0032
https://github.com/endlessm/linux/commit/75b0cea7bf30

-------------------------------------------------------------------------------
If you use vendor_db functionality of providing multiple certificates and/or
hashes please briefly describe your certificate setup. If there are allow-listed hashes
please provide exact binaries for which hashes are created via file sharing service,
available in public with anonymous access for verification
-------------------------------------------------------------------------------
We do not use the vendor_db functionality.

-------------------------------------------------------------------------------
If you are re-using a previously used (CA) certificate, you will need
to add the hashes of the previous GRUB2 binaries to vendor_dbx in shim
in order to prevent GRUB2 from being able to chainload those older GRUB2
binaries. If you are changing to a new (CA) certificate, this does not
apply. Please describe your strategy.
-------------------------------------------------------------------------------
The signing certificate we use to sign GRUB2 and the linux kernel image has
been replaced, and the previous signing certificates were added to the new
shim's vendor_dbx.

-------------------------------------------------------------------------------
What OS and toolchain must we use to reproduce this build?  Include where to find it, etc.  We're going to try to reproduce your build as close as possible to verify that it's really a build of the source tree you tell us it is, so these need to be fairly thorough. At the very least include the specific versions of gcc, binutils, and gnu-efi which were used, and where to find those binaries.
If the shim binaries can't be reproduced using the provided Dockerfile, please explain why that's the case and the differences would be.
-------------------------------------------------------------------------------
This was manually built on Debian Bullseye, to make it possible to reproduce,
since we currently don't ship development tools on Endless OS. The versions of
gcc, binutils and gnu-efi are listed bellow.

- gcc: 10.2.1
- binutils: 2.35.2
- gnu-efi: the version that is included as a git submodule in shim's tree

We are providing a Dockerfile in this repo that can be used to reproduce the
build pulling all dependencies from the public Debian repositories --
instructions are availabled in BUILDING.txt.

-------------------------------------------------------------------------------
Which files in this repo are the logs for your build?   This should include logs for creating the buildroots, applying patches, doing the build, creating the archives, etc.
-------------------------------------------------------------------------------
https://github.com/endlessm/shim-review/blob/endless-shim-x64-20210526/logs.txt

-------------------------------------------------------------------------------
Add any additional information you think we may need to validate this shim
-------------------------------------------------------------------------------
The `debian` directory with the package building recipes and scripts, vendor
certificate, vendor DBX contents etc, is available at
https://github.com/endlessm/shim/commits/debian-master, commit `22ed0e48`.

The downstream patches we are carrying here were also reviewed and approved in
our previous submissions. Our previous community review requests can be found
at https://github.com/rhboot/shim-review/issues/61 and
https://github.com/rhboot/shim-review/issues/105.
