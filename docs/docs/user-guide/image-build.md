## How to build a CES-image
### Requirements
* `git` installed
* `packer` installed
* `VirtualBox`, `QEMU` or `VMware` installed

### 1. Checkout the ecosystem repository
 * `git clone https://github.com/cloudogu/ecosystem.git`
### 2. Build the image with packer
* `packer build <ecosystem-path>/images/template.prod.json`
    * builds an image for production
    * with the parameter `--only=<image-type>` the image type can be configured to `ecosystem-virtualbox`, `ecosystem-vmware` or `ecosystem-qemu`
    * default user `ces-admin` with password `ces-admin` (will be changed in setup process)
* `packer build <ecosystem-path>/images/template.dev.json`
    * builds an image for development
    * additionally development tools, like `htop` and `jq` will be installed into the vm.
    A full list can be found in following files:
        * [dependencies.sh](https://github.com/cloudogu/ecosystem/blob/develop/images/scripts/dev/dependencies.sh)
        * [vagrant.sh](https://github.com/cloudogu/ecosystem/blob/develop/images/scripts/dev/vagrant.sh)
    * default user `vagrant` with password `vagrant`

### 3. Wait
* the image build process lasts around 45 minutes
### 4. Take the image
* the image(s) can be found in `<ecosystem-path>/images/output-*`
