<a href="https://cloudogu.com/">
    <img src="https://cloudogu.com/assets/logo-2d2238fe45628d112266028f575036b59b4dbb5f4bda38997b5888d536354ddc.png" alt="cloudogu logo" title="Cloudogu" align="right" />
</a>

# Cloudogu EcoSystem (CES)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
![Maintainer](https://img.shields.io/badge/maintainer-Cloudogu-blue)


This is the repository containing all setup scripts and resources to install a cloudogu ecosystem. 

<a href="https://docs.cloudogu.com/"><img src="https://my.cloudogu.com/images/icons/docsIcon.svg" width="50"> Documentation</a>
<a href="https://community.cloudogu.com/c/cloudogu-ecosystem/18"><img src="https://my.cloudogu.com/images/icons/talkIcon.svg" width="50"> Community</a>
<a href="https://cloudogu.windcloud.de/"><img src="https://my.cloudogu.com/images/icons/publicEcoSystemIcon.svg" width="50"> Public CES</a>


## Quick start

There are three ways to get your Cloudogu EcoSystem. The easiest is to register at https://my.cloudogu.com and download the VirtualBox image.  
If you don't want to do that, you can build it from scratch with vagrant or Packer.

<a href="https://cloudogu.com/en/ecosystem/download/"><img src="https://my.cloudogu.com/images/icons/virtualBoxIcon.svg" width="50">Download Image</a>

### 1. Download VirtualBox image from myCloudogu
* Install [virtualbox](https://www.virtualbox.org/)
* Register at [myCloudogu](https://my.cloudogu.com/) and download [vm image](https://files.cloudogu.com/file/ces-images/latest)
  * If you want to verify the integrity of the download, you can also get the [SHA256 hash](https://files.cloudogu.com/file/ces-images/SHA256SUMS)
* Follow the [quickstart guide](https://cloudogu.com/en/ecosystem/ces-quick-start-guide/?mtm_campaign=ecosystem&mtm_kwd=qsg&mtm_source=github&mtm_medium=link) at cloudogu.com.

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

### 3. Build with Packer

Download Packer from https://www.packer.io/downloads.html and move the extracted binary to `/usr/local/bin/packer`.

Build the VM according to your liking with one of the builders in `images/template.prod.json`.

### What is the Cloudogu EcoSystem?
The Cloudogu EcoSystem is an open platform, which lets you choose how and where your team creates great software. Each service or tool is delivered as a Dogu, a Docker container. Each Dogu can easily be integrated in your environment just by pulling it from our registry. We have a growing number of ready-to-use Dogus, e.g. SCM-Manager, Jenkins, Nexus, SonarQube, Redmine and many more. Every Dogu can be tailored to your specific needs. Take advantage of a central authentication service, a dynamic navigation, that lets you easily switch between the web UIs and a smart configuration magic, which automatically detects and responds to dependencies between Dogus. The Cloudogu EcoSystem is open source and it runs either on-premises or in the cloud. The Cloudogu EcoSystem is developed by Cloudogu GmbH under [MIT License](https://cloudogu.com/license/?mtm_campaign=ecosystem&mtm_kwd=license&mtm_source=github&mtm_medium=link).

---
&copy; 2021 Cloudogu GmbH - MADE WITH :heart:&nbsp;FOR DEV ADDICTS. [Legal notice / Impressum](https://cloudogu.com/en/imprint/?mtm_campaign=ecosystem&mtm_kwd=imprint&mtm_source=github&mtm_medium=link)
