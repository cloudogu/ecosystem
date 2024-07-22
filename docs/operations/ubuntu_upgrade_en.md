# Upgrading from Ubuntu 20.04 to 24.04

## 1. Upgrade Ubuntu 20.04 to 24.04

You can upgrade the Ubuntu distribution the Cloudogu EcoSystem is built on just like in any other Ubuntu based system.

## 2. Adjust apt configuration

After you have upgraded your EcoSystem to Ubuntu 24.04, you have to adapt some of the EcoSystem-specific apt configuration:

- Adjust the file `/etc/apt/sources.list.d/docker.list` from 20.04 (focal) to 24.04 (noble)
   - Insert this line: `deb [arch=amd64] https://download.docker.com/linux/ubuntu noble stable`
   - Remove old lines like `deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable`

- Adjust the file `/etc/apt/sources.list.d/hashicorp.list` from 20.04 (focal) to 24.04 (noble)
   - Insert this line: `deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com noble main`
   - Remove old lines like `deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com focal main`

- Keep the `focal` codename in the `/etc/apt/sources.list.d/ces.list` file.

- Check your work by running `sudo apt update`. It should report no errors.

## 3. Upgrade Docker

Make sure to run at least Docker 20.10, e.g. via `sudo docker info | grep Server\ Version`.
If you are still running Docker 19.03 (or older), you should upgrade, e.g. via `sudo apt update && sudo apt upgrade`.
