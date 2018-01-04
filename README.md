![Cloudogu logo](https://cloudogu.com/images/logo.png)
# Cloudogu EcoSystem
https://cloudogu.com

This is the repository of the cloudogu ecosystem. It contains all docker containers, setup scripts and resources to install cloudogu on your machine and start it using vagrant.

We also have a public demo instance available. All possibilities and details can be found on our [demo page](https://cloudogu.com/en/index.html#demo)

### Quick start
* Install [git](https://git-scm.com/)
* Install [virtualbox](https://www.virtualbox.org/)
* Install [vagrant](https://www.vagrantup.com/docs/getting-started/)
* Checkout ecosystem repository `git clone https://github.com/cloudogu/ecosystem`
* `cd ecosystem`
* `vagrant up` to run ecosystem in a virtual machine
* When vagrant is done, enter the following URL in your browser : http://192.168.56.2:8080
* Follow the steps of the setup wizard

#### Bridged Network

By default our vagrant configuration uses a host-only network, which makes the ecosystem only accessible from your machine. 

If you want it to be accessible from other hosts in your network, you can change this behavior in the [`Vagrantfile`](Vagrantfile). To do so,
* remove the `private_network` line and 
* uncomment the `public_network` line.

Next time you start the VM, it will use a bridged network and try to get an IP address from the network your host is in. 

By the way:
* You can shut down the VM by calling `vagrant halt`.  
* If you want to start over with a clean slate call `vagrant destroy`.

---
### What is Cloudogu?
Cloudogu is an open platform, which lets you choose how and where your team creates great software. Each service or tool is delivered as a [Dōgu](https://translate.google.com/?text=D%26%23x014d%3Bgu#ja/en/%E9%81%93%E5%85%B7), a Docker container, that can be easily integrated in your environment just by pulling it from our registry. We have a growing number of ready-to-use Dōgus, e.g. SCM-Manager, Jenkins, Nexus, SonarQube, Redmine and many more. Every Dōgu can be tailored to your specific needs. You can even bring along your own Dōgus! Take advantage of a central authentication service, a dynamic navigation, that lets you easily switch between the web UIs and a smart configuration magic, which automatically detects and responds to dependencies between Dōgus. Cloudogu is open source and it runs either on-premise or in the cloud. Cloudogu is developed by Cloudogu GmbH under [MIT License](https://cloudogu.com/license.html) and it runs either on-premise or in the cloud.

### How to get in touch?
Want to talk to the Cloudogu team? Need help or support? There are several ways to get in touch with us:

* [Website](https://cloudogu.com)
* [Mailing list](https://groups.google.com/forum/#!forum/cloudogu)
* [Email hello@cloudogu.com](mailto:hello@cloudogu.com)

---
&copy; 2017 Cloudogu GmbH - MADE WITH :heart: FOR DEV ADDICTS. [Legal notice / Impressum](https://cloudogu.com/imprint.html)