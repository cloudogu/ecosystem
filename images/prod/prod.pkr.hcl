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
  type    = string
  default = "4"
}

variable "disk_size" {
  type    = string
  default = "100000"
}

variable "iso_checksum" {
  type    = string
  default = "sha256:b8f31413336b9393ad5d8ef0282717b2ab19f007df2e9ed5196c13d8f9153c8b"
}

variable "iso_url" {
  type    = string
  default = "https://releases.ubuntu.com/20.04.6/ubuntu-20.04.6-live-server-amd64.iso"
}

variable "memory" {
  type    = string
  default = "8192"
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

locals {
  vm_name = "CloudoguEcoSystem-${var.timestamp}"
}

source "qemu" "ecosystem-qemu" {
  boot_command           = ["<enter><enter><f6><esc><wait> ", "autoinstall ds=nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ ", "<enter>"]
  boot_wait              = "1s"
  disk_size              = "${var.disk_size}"
  format                 = "qcow2"
  headless               = false
  http_directory         = "http/QEMU"
  iso_checksum           = "${var.iso_checksum}"
  iso_url                = "${var.iso_url}"
  qemuargs               = [["-m", "${var.memory}"], ["-smp", "${var.cpus}"]]
  shutdown_command       = "echo ${var.username} | sudo -S -E shutdown -P now"
  ssh_handshake_attempts = "10000"
  ssh_password           = "${var.password}"
  ssh_timeout            = "15m"
  ssh_username           = "${var.username}"
  vm_name                = "${local.vm_name}.qcow2"
}

source "virtualbox-iso" "ecosystem-virtualbox" {
  boot_command           = ["<enter><enter><f6><esc><wait> ", "autoinstall ds=nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ ", "<enter>"]
  boot_wait              = "5s"
  disk_size              = "${var.disk_size}"
  format                 = "ova"
  guest_os_type          = "Ubuntu_64"
  hard_drive_interface   = "sata"
  headless               = false
  http_directory         = "http"
  iso_checksum           = "${var.iso_checksum}"
  iso_url                = "${var.iso_url}"
  shutdown_command       = "echo ${var.username} | sudo -S -E shutdown -P now"
  ssh_handshake_attempts = "10000"
  ssh_password           = "${var.password}"
  ssh_timeout            = "15m"
  ssh_username           = "${var.username}"
  vboxmanage             = [["modifyvm", "${local.vm_name}", "--memory", "${var.memory}"], ["modifyvm", "${local.vm_name}", "--cpus", "${var.cpus}"], ["modifyvm", "${local.vm_name}", "--vram", "10"]]
  vm_name                = "${local.vm_name}"
}

source "vmware-iso" "ecosystem-vmware" {
  boot_command           = ["<enter><enter><f6><esc><wait> ", "autoinstall ds=nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ ", "<enter>"]
  boot_wait              = "5s"
  cpus                   = "${var.cpus}"
  disk_size              = "${var.disk_size}"
  guest_os_type          = "ubuntu-64"
  headless               = false
  http_directory         = "http"
  iso_checksum           = "${var.iso_checksum}"
  iso_urls               = ["${var.iso_url}"]
  memory                 = "${var.memory}"
  shutdown_command       = "echo ${var.username} | sudo -S -E shutdown -P now"
  ssh_handshake_attempts = "10000"
  ssh_password           = "${var.password}"
  ssh_timeout            = "15m"
  ssh_username           = "${var.username}"
  tools_upload_flavor    = "linux"
  version                = "14"
  vm_name                = "${local.vm_name}"
}

build {
  sources = ["source.qemu.ecosystem-qemu", "source.virtualbox-iso.ecosystem-virtualbox", "source.vmware-iso.ecosystem-vmware"]

  provisioner "file" {
    destination = "/home/${var.username}"
    source      = "../install"
  }

  provisioner "file" {
    destination = "/home/${var.username}"
    source      = "../resources"
  }

  provisioner "shell" {
    environment_vars  = ["INSTALL_HOME=/home/${var.username}", "HOME_DIR=/home/${var.username}"]
    execute_command   = "echo ${var.password} | {{ .Vars }} sudo -S -E /bin/bash -eux '{{ .Path }}'"
    expect_disconnect = true
    scripts           = ["scripts/commons/ces_apt.sh", "scripts/commons/update.sh"]
  }

  provisioner "shell" {
    environment_vars  = ["INSTALL_HOME=/home/${var.username}", "HOME_DIR=/home/${var.username}"]
    execute_command   = "echo ${var.password} | {{ .Vars }} sudo -S -E /bin/bash -eux '{{ .Path }}'"
    expect_disconnect = true
    pause_before      = "5s"
    scripts           = ["scripts/commons/dependencies.sh", "scripts/commons/sshd.sh", "scripts/commons/grub.sh", "scripts/commons/subvolumes.sh", "scripts/commons/guestadditions.sh", "scripts/commons/docker.sh", "scripts/commons/terraform.sh", "scripts/commons/fail2ban.sh", "scripts/commons/etcd.sh", "../install.sh", "scripts/commons/networking.sh", "scripts/prod/sshd_security.sh", "scripts/commons/cleanup.sh", "scripts/commons/minimize.sh"]
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
