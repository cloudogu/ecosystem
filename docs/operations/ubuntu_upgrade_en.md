# Upgrading from Ubuntu 18.04 to 20.04 in the Cloudogu EcoSystem

## 1. Upgrade Ubuntu 18.04 to 20.04

You can upgrade the Ubuntu distribution the EcoSystem is built on just like in any other Ubuntu based system. A good reference about the steps to take can be found here: https://www.linuxcloudvps.com/blog/how-to-update-your-server-from-ubuntu-18-04-to-ubuntu-20-04/

## 2. Adjust apt configuration

After you have upgraded your EcoSystem to Ubuntu 20.04, you have to adapt some of the EcoSystem-specific apt configuration:

- Adjust the file `/etc/apt/sources.list.d/ces.list` from 18.04 (bionic) to 20.04 (focal)
   - Insert this line: `deb [arch=amd64] https://apt.cloudogu.com/ces/ focal main`
   - Remove old lines like `deb [arch=amd64] https://apt.cloudogu.com/ces/ bionic main`

- Adjust the file `/etc/apt/sources.list.d/docker.list` from 18.04 (bionic) to 20.04 (focal)
   - Insert this line: `deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable`
   - Remove old lines like `deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable`

- Adjust the file `/etc/apt/sources.list.d/hashicorp.list` from 18.04 (bionic) to 20.04 (focal)
   - Insert this line: `deb [arch=amd64] https://apt.releases.hashicorp.com focal main`
   - Remove old lines like `deb [arch=amd64] https://apt.releases.hashicorp.com bionic main`

- Check your work by running `sudo apt update`. It should report no errors.

## 3. Upgrade Docker

Make sure to run at least Docker 20.10, e.g. via `sudo docker info | grep Server\ Version`.
If you are still running Docker 19.03 (or older), you should upgrade, e.g. via `sudo apt update && sudo apt upgrade`.
