# How to build a CES-image
## Requirements
* `git` installed
* `packer` installed (see [packer.io](https://www.packer.io/))
* `VirtualBox`, `QEMU` and/or `VMware` installed

## 1. Check out the ecosystem repository
 * `git clone https://github.com/cloudogu/ecosystem.git`
## 2. Build the image(s) with packer
* `cd <ecosystem-path>/images/`
* `packer build -var "timestamp=$(date +%Y%m%d)" template.prod.json`
    * Builds all images for production
    * To get only a specific build for one of the hypervisors, use the`--only=<image-type>` parameter. With it, the image type can be configured to `ecosystem-virtualbox`, `ecosystem-vmware` or `ecosystem-qemu`
    * The default user is `ces-admin` with password `ces-admin` (will be changed in setup process)
* `packer build template.dev.json`
    * Builds an image for development
    * Adds development tools like `htop` and `jq` to the the vm.
    A full list can be found in the following files:
        * [dependencies.sh](https://github.com/cloudogu/ecosystem/blob/develop/images/scripts/dev/dependencies.sh)
        * [vagrant.sh](https://github.com/cloudogu/ecosystem/blob/develop/images/scripts/dev/vagrant.sh)
    * The default user is `vagrant` with password `vagrant`

## 3. Wait
* The image build process lasts around 45 minutes, depending on your hardware
## 4. Finish
* The image(s) can be found in `<ecosystem-path>/images/output-*`
