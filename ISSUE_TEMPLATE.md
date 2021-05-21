Make sure you have provided the following information:

 - [x] link to your code branch cloned from rhboot/shim-review in the form user/repo@tag
   endlessm/shim-review@endless-shim-x64-20210526
 - [x] completed README.md file with the necessary information
   https://github.com/endlessm/shim-review/blob/endless-shim-x64-20210526/README.md
 - [x] shim.efi to be signed
   https://github.com/endlessm/shim-review/blob/endless-shim-x64-20210526/shimx64.efi
 - [x] public portion of your certificate(s) embedded in shim (the file passed to VENDOR_CERT_FILE)
   https://github.com/endlessm/shim-review/blob/endless-shim-x64-20210526/endless-uefi-ca.der
 - [x] binaries, for which hashes are added do vendor_db ( if you use vendor_db and have hashes allow-listed )
   No hashes are added to vendor_db, we do not use this functionality
 - [x] any extra patches to shim via your own git tree or as files
   The last 4 commits on https://github.com/endlessm/shim/commits/master.
 - [x] any extra patches to grub via your own git tree or as files
   The grub source code we use can be found on the master branch of
   https://github.com/endlessm/grub. We are based on tag grub-2.04 from
   upstream, and Debian's package version 2.04-16.
 - [x] build logs
   https://github.com/endlessm/shim-review/blob/endless-shim-x64-20210526/logs.txt
 - [x] a Dockerfile to reproduce the build of the provided shim EFI binaries
   https://github.com/endlessm/shim-review/blob/endless-shim-x64-20210526/Dockerfile


###### What organization or people are asking to have this signed:
Endless OS Foundation LLC
https://endlessos.org/

###### What product or service is this for:
Endless OS.

###### Please create your shim binaries starting with the 15.4 shim release tar file:
###### https://github.com/rhboot/shim/releases/download/15.4/shim-15.4.tar.bz2
###### This matches https://github.com/rhboot/shim/releases/tag/15.4 and contains
###### the appropriate gnu-efi source.
###### Please confirm this as the origin your shim.

Yes, we are based on upstream commit `4068fd42`, which is 4 commits on top of tag `15.4`.

###### What's the justification that this really does need to be signed for the whole world to be able to boot it:
Endless OS is a Linux distribution available for download on
https://endlessos.com/download/ and also shipped with computers sold directly
by us and by our OEM partners like Asus and Acer.

###### How do you manage and protect the keys used in your SHIM?
We have generated our own secure boot CA private key which is stored offline
with physical security protection and only accessed to provision new signing
keys. The CA public key is the one embedded in the shim binary. The signing
keys which are used in our build servers to sign the bootloader and kernel are
stored in J3A081 80K smartcard HW encryption devices. This is based on the
procedure described at
https://fedoraproject.org/wiki/User:Pjones/SecureBootSmartCardDeployment

###### Do you use EV certificates as embedded certificates in the SHIM?
No.

###### If you use new vendor_db functionality, are any hashes allow-listed, and if yes: for what binaries ?
We do not use the vendor_db functionality.

###### Is kernel upstream commit 75b0cea7bf307f362057cc778efe89af4c615354 present in your kernel, if you boot chain includes a Linux kernel ?
Yes, https://github.com/endlessm/linux/commit/75b0cea7bf30

###### if SHIM is loading GRUB2 bootloader, are CVEs CVE-2020-14372,
###### CVE-2020-25632, CVE-2020-25647, CVE-2020-27749, CVE-2020-27779,
###### CVE-2021-20225, CVE-2021-20233, CVE-2020-10713, CVE-2020-14308,
###### CVE-2020-14309, CVE-2020-14310, CVE-2020-14311, CVE-2020-15705,
###### ( July 2020 grub2 CVE list + March 2021 grub2 CVE list )
###### and if you are shipping the shim_lock module CVE-2021-3418
###### fixed ?
Yes.

###### "Please specifically confirm that you add a vendor specific SBAT entry for SBAT header in each binary that supports SBAT metadata
###### ( grub2, fwupd, fwupdate, shim + all child shim binaries )" to shim review doc ?
Yes.

###### Please provide exact SBAT entries for all SBAT binaries you are booting or planning to boot directly through shim
GRUB2:
```
sbat,1,SBAT Version,sbat,1,https://github.com/rhboot/shim/blob/main/SBAT.md
grub,1,Free Software Foundation,grub,2.04,https://www.gnu.org/software/grub/
grub.debian,1,Debian,grub2,2.04-16,https://tracker.debian.org/pkg/grub2
grub.endless,1,Endless OS Foundation LLC,grub2,2.04+dev245.7421863-28bem1,https://github.com/endlessm/grub
```

##### Were your old SHIM hashes provided to Microsoft ?
Yes.

##### Did you change your certificate strategy, so that affected by CVE-2020-14372, CVE-2020-25632, CVE-2020-25647, CVE-2020-27749,
##### CVE-2020-27779, CVE-2021-20225, CVE-2021-20233, CVE-2020-10713,
##### CVE-2020-14308, CVE-2020-14309, CVE-2020-14310, CVE-2020-14311, CVE-2020-15705 ( July 2020 grub2 CVE list + March 2021 grub2 CVE list )
##### grub2 bootloaders can not be verified ?
Yes, the signing certificate we use to sign GRUB2 and the linux kernel image
has been replaced, and the previous signing certificates were added to the new
shim's vendor_dbx.

##### What exact implementation of Secureboot in grub2 ( if this is your bootloader ) you have ?
##### * Upstream grub2 shim_lock verifier or * Downstream RHEL/Fedora/Debian/Canonical like implementation ?
Downstream implementation from Debian.

###### What is the origin and full version number of your bootloader (GRUB or other)?
We use Debian's GRUB2 version 2.04-16 as base, including their downstream
changes.

The GRUB2 source code we use can be found at https://github.com/endlessm/grub,
on branches master (for code) and debian-master (for packaging). Our master
branch is based on tag grub-2.04 from upstream.

###### If your SHIM launches any other components, please provide further details on what is launched
Our shim does not launch any other components.

###### If your GRUB2 launches any other binaries that are not Linux kernel in SecureBoot mode,
###### please provide further details on what is launched and how it enforces Secureboot lockdown
Our GRUB2 does not launch any other components.

###### If you are re-using a previously used (CA) certificate, you
###### will need to add the hashes of the previous GRUB2 binaries
###### exposed to the CVEs to vendor_dbx in shim in order to prevent
###### GRUB2 from being able to chainload those older GRUB2 binaries. If
###### you are changing to a new (CA) certificate, this does not
###### apply. Please describe your strategy.
We are revoking the certificate associated with the key we used to sign UEFI
binaries via shim's vendor_dbx.

###### How do the launched components prevent execution of unauthenticated code?
N/A.

###### Does your SHIM load any loaders that support loading unsigned kernels (e.g. GRUB)?
No, the GRUB version we ship does not allow loading unsigned kernels under
secure boot. The `linux` loader in our grub EFI binary always hands-off loading
to the `linuxefi` module, which verifies the kernel via the shim protocol under
secure boot.

###### What kernel are you using? Which patches does it includes to enforce Secure Boot?
We are currently based on Linux 5.11, which includes the most recent fixes for
secure boot enforcement. We will likely rebase onto a newer kernel before
releasing the next version of Endless OS, which will be the first to include
this shim.

###### What changes were made since your SHIM was last signed?
Rebased on a newer upstream version. All signing certificates used to sign
previous versions of GRUB or the Linux kernel are being included in shim's
internal `vendor_dbx`, via the build-time macro `VENDOR_DBX_FILE`.

###### What is the SHA256 hash of your final SHIM binary?
440bce4126b96d1f2c3ad3a75f34d36b74fbf1dec6045645fcb4dbe0fb7dba91  shimx64.efi
