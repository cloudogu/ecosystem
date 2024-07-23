packer {
  required_plugins {
    qemu = {
      source  = "github.com/hashicorp/qemu"
      version = "~> 1"
    }
    virtualbox = {
      source  = "github.com/hashicorp/virtualbox"
      version = "~> 1"
    }
    vmware = {
      source  = "github.com/hashicorp/vmware"
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
  default = "ces-admin"
}

variable "timestamp" {
  type = string
}

variable "username" {
  type    = string
  default = "ces-admin"
}

variable "virtualbox-version-lower-7" {
  type = bool
  description = "This flag indicates that the local virtualbox version you are using is older than version 7. It is used to create the modifyvm option list, because some options are not available with virtualbox < 7"
  default = false
}

locals {
  vm_name = "CloudoguEcoSystem-${var.timestamp}"
  common_vboxmanage = [["modifyvm", "${local.vm_name}", "--memory", "${var.memory}"], ["modifyvm", "${local.vm_name}", "--cpus", "${var.cpus}"], ["modifyvm", "${local.vm_name}", "--vram", "10"]]
  vboxmanage = var.virtualbox-version-lower-7 ? local.common_vboxmanage : concat(local.common_vboxmanage, [["modifyvm", local.vm_name, "--nat-localhostreachable1", "on"]])
  boot_command = [
    "c<wait>",
    "set gfxpayload=keep<enter><wait>",
    "linux /casper/vmlinuz <wait>",
    "autoinstall fsck.mode=skip noprompt <wait>",
    "ds=\"nocloud;s=http://{{.HTTPIP}}:{{.HTTPPort}}/\"<enter><wait>",
    "initrd /casper/initrd<enter><wait>",
    "boot<enter>"
  ]
  boot_wait              = "5s"
  headless               = false
  shutdown_command       = "echo ${var.username} | sudo -S -E shutdown -P now"
  ssh_handshake_attempts = 10000
  ssh_timeout            = "20m"
}

source "qemu" "ecosystem-qemu" {
  boot_command           = local.boot_command
  boot_wait              = local.boot_wait
  disk_size              = var.disk_size
  format                 = "qcow2"
  headless               = local.headless
  http_directory         = "http/QEMU"
  iso_checksum           = var.iso_checksum
  iso_url                = var.iso_url
  qemuargs               = [["-m", "${var.memory}"], ["-smp", "${var.cpus}"]]
  shutdown_command       = local.shutdown_command
  ssh_handshake_attempts = local.ssh_handshake_attempts
  ssh_password           = var.password
  ssh_timeout            = local.ssh_timeout
  ssh_username           = var.username
  vm_name                = "${local.vm_name}.qcow2"
}

source "virtualbox-iso" "ecosystem-virtualbox" {
  boot_command           = local.boot_command
  boot_wait              = local.boot_wait
  disk_size              = var.disk_size
  format                 = "ova"
  guest_os_type          = "Ubuntu_64"
  hard_drive_interface   = "sata"
  headless               = local.headless
  http_directory         = "http"
  iso_checksum           = var.iso_checksum
  iso_url                = var.iso_url
  shutdown_command       = "echo ${var.username} | sudo -S -E shutdown -P now"
  ssh_handshake_attempts = 10000
  ssh_password           = var.password
  ssh_timeout            = "20m"
  ssh_username           = var.username
  vboxmanage             = local.vboxmanage
  vm_name                = local.vm_name
}

source "vmware-iso" "ecosystem-vmware" {
  boot_command           = local.boot_command
  boot_wait              = local.boot_wait
  cpus                   = var.cpus
  disk_size              = var.disk_size
  guest_os_type          = "ubuntu-64"
  headless               = local.headless
  http_directory         = "http"
  iso_checksum           = var.iso_checksum
  iso_urls               = ["${var.iso_url}"]
  memory                 = var.memory
  shutdown_command       = "echo ${var.username} | sudo -S -E shutdown -P now"
  ssh_handshake_attempts = 10000
  ssh_password           = var.password
  ssh_timeout            = "20m"
  ssh_username           = var.username
  tools_upload_flavor    = "linux"
  version                = "14"
  vm_name                = local.vm_name
}

build {
  sources = ["source.qemu.ecosystem-qemu", "source.virtualbox-iso.ecosystem-virtualbox", "source.vmware-iso.ecosystem-vmware"]

  provisioner "file" {
    destination = "/home/${var.username}"
    source      = "../../install"
  }

  provisioner "file" {
    destination = "/home/${var.username}"
    source      = "../../resources"
  }

  provisioner "shell" {
    environment_vars  = ["INSTALL_HOME=/home/${var.username}", "HOME_DIR=/home/${var.username}"]
    execute_command   = "echo ${var.password} | {{ .Vars }} sudo -S -E /bin/bash -eux '{{ .Path }}'"
    expect_disconnect = true
    scripts           = ["../scripts/commons/ces_apt.sh", "../scripts/commons/update.sh"]
  }

  provisioner "shell" {
    environment_vars  = ["INSTALL_HOME=/home/${var.username}", "HOME_DIR=/home/${var.username}"]
    execute_command   = "echo ${var.password} | {{ .Vars }} sudo -S -E /bin/bash -eux '{{ .Path }}'"
    expect_disconnect = true
    pause_before      = "5s"
    scripts           = [
      "../scripts/commons/dependencies.sh",
      "../scripts/commons/sshd.sh",
      "../scripts/commons/grub.sh",
      "../scripts/commons/subvolumes.sh",
      "../scripts/commons/guestadditions.sh",
      "../scripts/commons/docker.sh",
      "../scripts/commons/terraform.sh",
      "../scripts/commons/fail2ban.sh",
      "../scripts/commons/etcd.sh",
      "../../install.sh",
      "../scripts/commons/networking.sh",
      "../scripts/prod/sshd_security.sh",
      "../scripts/commons/cleanup.sh",
      "../scripts/commons/minimize.sh"
    ]
  }

  post-processor "checksum" {
    checksum_types = ["sha256"]
    output         = "build/SHA256SUMS"
  }
  post-processor "compress" {
    compression_level = 6
    output            = "build/${local.vm_name}.tar.gz"
  }
}
