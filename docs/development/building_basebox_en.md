# Building the EcoSystem Development Basebox

This document contains the necessary information to build the development basebox required to start a development
instance of the Cloudogu EcoSystem. The basebox contains tools and installations to reduce the effort for creating a 
new development instance via Vagrant.

## Requirements
- `git` installed
- `packer` installed (see [packer.io](https://www.packer.io/))
- `VirtualBox` installed
- Understanding the [Structure of the Project Files](structure_of_the_files_en.md)

## Building the Basebox

**1. Clone the k8s-ecosystem repository**

```bash
git clone https://github.com/cloudogu/k8s-ecosystem.git
```

**2. Build image**

```bash
cd <k8s-ecosystem-path>/images/dev/
packer init .
packer build dev.pkr.hcl
```

If you are using a VirtualBox version below 7, you need to set a build variable:

```bash
packer build -var virtualbox-version-lower-7=true dev.pkr.hcl
```

**3. Wait**

The image building process takes about 15 minutes, depending on your hardware and internet connection. Packer should
create a resulting basebox named `ecosystem-basebox.box` in the `images/dev/build` folder.
