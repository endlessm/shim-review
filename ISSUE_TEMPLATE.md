Confirm the following are included in your repo, checking each box:

 - [x] completed README.md file with the necessary information
   https://github.com/endlessm/shim-review/blob/endless-shim-x64-20240822/README.md
 - [x] shim.efi to be signed
   https://github.com/endlessm/shim-review/blob/endless-shim-x64-20240822/shimx64.efi
 - [x] public portion of your certificate(s) embedded in shim (the file passed to VENDOR_CERT_FILE)
   https://github.com/endlessm/shim-review/blob/endless-shim-x64-20240822/endless-uefi-ca.der
 - [x] binaries, for which hashes are added to vendor_db ( if you use vendor_db and have hashes allow-listed )
   We do not use the vendor_db functionality.
 - [x] any extra patches to shim via your own git tree or as files
   https://github.com/endlessm/shim/tree/endless/15.8-1_deb12u1endless1/debian/patches
 - [x] any extra patches to grub via your own git tree or as files
   The full set of patches relative to 2.06 can be viewed at
   https://github.com/endlessm/grub/compare/grub-2.06...Release_6.0.2 The
   commits with `[DEB]` prefix come from Debian's `2.06-13+deb12u1` release.
   All other commits are Endless specific.
 - [x] build logs
   https://github.com/endlessm/shim-review/blob/endless-shim-x64-20240822/buildlog.txt
 - [x] a Dockerfile to reproduce the build of the provided shim EFI binaries
   https://github.com/endlessm/shim-review/blob/endless-shim-x64-20240822/Dockerfile

*******************************************************************************
### What is the link to your tag in a repo cloned from rhboot/shim-review?
*******************************************************************************
https://github.com/endlessm/shim-review/releases/tag/endless-shim-x64-20240822

*******************************************************************************
### What is the SHA256 hash of your final SHIM binary?
*******************************************************************************
`7859e02e1fc6dff8e2b221dfcbfaffcb6d1e95e2acb65403e5db7c849f9221cd`

*******************************************************************************
### What is the link to your previous shim review request (if any, otherwise N/A)?
*******************************************************************************
https://github.com/rhboot/shim-review/issues/176

*******************************************************************************
### If no security contacts have changed since verification, what is the link to your request, where they've been verified (if any, otherwise N/A)?
*******************************************************************************
The security contacts have not changed, however I can't find any indication of
verification in any previous reviews. Those are:

https://github.com/rhboot/shim-review/issues/176
https://github.com/rhboot/shim-review/issues/105
https://github.com/rhboot/shim-review/issues/61
