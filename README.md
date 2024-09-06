<p align="center">
    <a href="https://cloudogu.com/">
        <img src="https://cloudogu.com/assets/cloudogu-logo-f1f26e5c32f240d0a161cebe71e91138ee5662c1f99fb314539a4763ef5959a946130f1a12e9bc39c83c127092a66b919d1fae86fadd5fe9639d06032787a03d.svg" alt="Cloudogu Logo" title="Cloudogu Logo" align="center"  width="300"/>
    </a>
</p>
<br>

# Cloudogu EcoSystem (CES)
![Maintainer](https://img.shields.io/badge/maintainer-Cloudogu-blue)


This is the repository containing all setup scripts and resources to install a Cloudogu EcoSystem.
For help, you can have a look at our documentation or ask a question in our community.
<br><br>
<p align="center">
   <a href="https://docs.cloudogu.com/?mtm_campaign=ecosystem&mtm_kwd=imprint&mtm_source=github&mtm_medium=link">
       <img src="https://my.cloudogu.com/images/icons/docsIcon.svg" width="30">
   </a> 
    <a href="https://docs.cloudogu.com/?mtm_campaign=ecosystem&mtm_kwd=imprint&mtm_source=github&mtm_medium=link">Documentation</a>
    &nbsp;&nbsp;
    <a href="https://community.cloudogu.com/c/cloudogu-ecosystem/18?mtm_campaign=ecosystem&mtm_kwd=imprint&mtm_source=github&mtm_medium=link">
        <img src="https://my.cloudogu.com/images/icons/talkIcon.svg" width="30">
    </a>
    <a href="https://community.cloudogu.com/c/cloudogu-ecosystem/18?mtm_campaign=ecosystem&mtm_kwd=imprint&mtm_source=github&mtm_medium=link" style="color: #00629E;">Community</a>
</p>
<br>


## Quick start

There are three ways to get your Cloudogu EcoSystem. The easiest is to register at the [Cloudogu Platform](https://platform.cloudogu.com/?mtm_campaign=ecosystem&mtm_kwd=imprint&mtm_source=github&mtm_medium=link) and download the VirtualBox or QEMU image. Alternatively, you can create it from scratch with Vagrant or Packer.
 * [Download VirtualBox Image](https://platform.cloudogu.com/de/downloads/ces-virtualbox/?mtm_campaign=ecosystem&mtm_kwd=imprint&mtm_source=github&mtm_medium=link)
 * [Download QEMU Image](https://platform.cloudogu.com/de/downloads/ces-qemu/?mtm_campaign=ecosystem&mtm_kwd=imprint&mtm_source=github&mtm_medium=link)

### 1. Download VirtualBox or QEMU image from the Cloudogu Platform
* Install [VirtualBox](https://www.virtualbox.org/) or [QEMU](https://www.qemu.org/)
* Register at the [platform](https://platform.cloudogu.com/?mtm_campaign=ecosystem&mtm_kwd=imprint&mtm_source=github&mtm_medium=link) and download the image for [VirtualBox](https://platform.cloudogu.com/de/downloads/ces-virtualbox/?mtm_campaign=ecosystem&mtm_kwd=imprint&mtm_source=github&mtm_medium=link) or [QEMU](https://platform.cloudogu.com/de/downloads/ces-qemu/?mtm_campaign=ecosystem&mtm_kwd=imprint&mtm_source=github&mtm_medium=link)
  * If you want to verify the integrity of the download, you can also get the [SHA256 hash](https://files.cloudogu.com/file/ces-images/virtualbox/SHA256SUMS/?mtm_campaign=ecosystem&mtm_kwd=imprint&mtm_source=github&mtm_medium=link)
* Follow the [quickstart guide](https://cloudogu.com/en/ecosystem/ces-quick-start-guide/?mtm_campaign=ecosystem&mtm_kwd=qsg&mtm_source=github&mtm_medium=link) at cloudogu.com.
<br><br><br>

### 2. Build from scratch with vagrant
* Install [git](https://git-scm.com/)
* Install [virtualbox](https://www.virtualbox.org/)
* Install [vagrant](https://www.vagrantup.com/docs/getting-started/)
* Checkout EcoSystem repository `git clone https://github.com/cloudogu/ecosystem`
* `cd ecosystem`
* `vagrant up` to run EcoSystem in a virtual machine
* When vagrant is done, enter the following URL in your browser : http://192.168.56.2:8080
* Follow the steps of the setup wizard

#### VM configuration (bridged network)

By default our vagrant configuration uses a host-only network, which makes the EcoSystem only accessible from your machine. 

If you want it to be accessible from other hosts in your network, you can change this behavior in the [`Vagrantfile`](Vagrantfile). To do so,
* remove the `private_network` line and 
* uncomment the `public_network` line.

Next time you start the VM, it will use a bridged network and try to get an IP address from the network your host is in. 

By the way:
* You can shut down the VM by calling `vagrant halt`.  
* If you want to start over with a clean slate call `vagrant destroy`.
<br><br><br>
### 3. Build with Packer

Download Packer from https://www.packer.io/downloads.html and move the extracted binary to `/usr/local/bin/packer`.

Build the VM according to your liking with one of the builders in `images/template.prod.json`.
<br><br>
## What is the Cloudogu EcoSystem?
The Cloudogu EcoSystem is an open platform, which lets you choose how and where your team creates great software. Each service or tool is delivered as a Dogu, a Docker container. Each Dogu can easily be integrated in your environment just by pulling it from our registry. 

We have a growing number of ready-to-use Dogus, e.g. SCM-Manager, Jenkins, Nexus Repository, SonarQube, Redmine and many more. Every Dogu can be tailored to your specific needs. Take advantage of a central authentication service, a dynamic navigation, that lets you easily switch between the web UIs and a smart configuration magic, which automatically detects and responds to dependencies between Dogus. 

The Cloudogu EcoSystem is open source and it runs either on-premises or in the cloud. The Cloudogu EcoSystem is developed by Cloudogu GmbH under [AGPL-3.0-only](https://spdx.org/licenses/AGPL-3.0-only.html).

## License
Copyright © 2020 - present Cloudogu GmbH
This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, version 3.
This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
You should have received a copy of the GNU Affero General Public License along with this program. If not, see https://www.gnu.org/licenses/.
See [LICENSE](LICENSE) for details.


---
MADE WITH :heart:&nbsp;FOR DEV ADDICTS. [Legal notice / Imprint](https://cloudogu.com/en/imprint/?mtm_campaign=ecosystem&mtm_kwd=imprint&mtm_source=github&mtm_medium=link)
