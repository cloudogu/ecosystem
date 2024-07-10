packer {
  required_plugins {
    vagrant = {
      source  = "github.com/hashicorp/vagrant"
      version = "~> 1"
    }
    virtualbox = {
      source  = "github.com/hashicorp/virtualbox"
      version = "~> 1"
    }
  }
}

variable "cpus" {
  type    = number
  default = 4
}

variable "disk_size" {
  type    = number
  default = 100000
}

variable "iso_checksum" {
  type    = string
  default = "sha256:8762f7e74e4d64d72fceb5f70682e6b069932deedb4949c6975d0f0fe0a91be3"
}

variable "iso_url" {
  type    = string
  default = "https://releases.ubuntu.com/noble/ubuntu-24.04-live-server-amd64.iso"
}

variable "memory" {
  type    = number
  default = 8192
}

variable "password" {
  type    = string
  default = "vagrant"
}

variable "username" {
  type    = string
  default = "vagrant"
}

variable "vm_name" {
  type    = string
  default = "ces"
}

variable "virtualbox-version-lower-7" {
  type = bool
  description = "This flag indicates that the local virtualbox version you are using is older than version 7. It is used to create the modifyvm option list, because some options are not available with virtualbox < 7"
  default = false
}

locals {
  common_vboxmanage = [["modifyvm", "${var.vm_name}", "--memory", "${var.memory}"], ["modifyvm", "${var.vm_name}", "--cpus", "${var.cpus}"], ["modifyvm", "${var.vm_name}", "--vram", "10"]]
  vboxmanage = var.virtualbox-version-lower-7 ? local.common_vboxmanage : concat(local.common_vboxmanage, [["modifyvm", var.vm_name, "--nat-localhostreachable1", "on"]])
}

source "virtualbox-iso" "ecosystem-basebox" {
  boot_command           = [
    "c<wait>",
    "set gfxpayload=keep<enter><wait>",
    "linux /casper/vmlinuz <wait>",
    "autoinstall fsck.mode=skip noprompt <wait>",
    "ds=\"nocloud;s=http://{{.HTTPIP}}:{{.HTTPPort}}/\"<enter><wait>",
    "initrd /casper/initrd<enter><wait>",
    "boot<enter>"
  ]
  boot_wait              = "5s"
  disk_size              = var.disk_size
  guest_os_type          = "Ubuntu_64"
  hard_drive_interface   = "sata"
  headless               = false
  http_directory         = "http"
  iso_checksum           = var.iso_checksum
  iso_url                = var.iso_url
  shutdown_command       = "echo ${var.username} | sudo -S -E shutdown -P now"
  ssh_handshake_attempts = "10000"
  ssh_password           = var.password
  ssh_timeout            = "20m"
  ssh_username           = var.username
  vboxmanage             = local.vboxmanage
  vm_name                = "${var.vm_name}"
}

build {
  sources = ["source.virtualbox-iso.ecosystem-basebox"]

  provisioner "shell" {
    environment_vars  = ["INSTALL_HOME=/vagrant", "HOME_DIR=/home/${var.username}"]
    execute_command   = "echo ${var.password} | {{ .Vars }} sudo -S -E /bin/bash -eux '{{ .Path }}'"
    expect_disconnect = true
    scripts           = ["../scripts/commons/ces_apt.sh", "../scripts/commons/update.sh"]
  }

  provisioner "shell" {
    environment_vars = ["INSTALL_HOME=/vagrant", "HOME_DIR=/home/${var.username}"]
    execute_command  = "echo ${var.password} | {{ .Vars }} sudo -S -E /bin/bash -eux '{{ .Path }}'"
    pause_before     = "5s"
    scripts          = ["../scripts/commons/dependencies.sh", "../scripts/commons/sshd.sh", "../scripts/commons/grub.sh", "../scripts/commons/subvolumes.sh", "../scripts/commons/guestadditions.sh", "../scripts/dev/vagrant.sh", "../scripts/dev/dependencies.sh", "../scripts/commons/docker.sh", "../scripts/commons/terraform.sh", "../scripts/commons/fail2ban.sh", "../scripts/commons/etcd.sh", "../scripts/commons/networking.sh", "../scripts/commons/cleanup.sh", "../scripts/commons/minimize.sh"]
  }

  post-processor "vagrant" {
    output = "build/{{ .BuildName }}.box"
  }
}
