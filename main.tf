terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.1-rc6"
    }
  }
}

provider "proxmox" {
  pm_api_url           = var.pm_api_url
  pm_api_token_id      = var.pm_api_token_id
  pm_api_token_secret  = var.pm_api_token_secret
  pm_tls_insecure      = var.pm_tls_insecure
}

# Get the next available VMID using an external script
data "external" "next_vmid" {
  program = ["bash", "${path.module}/get_next_vmid.sh"]
}

resource "proxmox_vm_qemu" "ubuntu_vm" {
  name        = "ubuntu-vm"
  target_node = "hydra"
  vmid        = data.external.next_vmid.result["next_vmid"] # Dynamic VMID
  clone       = "ubuntu-cloud-template"

  os_type     = "cloud-init"
  cores       = 2
  memory      = 2048
  scsihw      = "virtio-scsi-pci"
  bootdisk    = "scsi0"

  disk {
    slot        = "scsi0"
    type        = "disk"
    storage     = "local-lvm"
    size        = "10G"
  }

  network {
    id          = 0
    model       = "virtio"
    bridge      = "vmbr0"
  }

  ciuser      = var.ci_user
  cipassword  = var.ci_password
  ipconfig0   = "ip=dhcp"

  provisioner "local-exec" {
    command = "echo VM deployed successfully!"
  }
}

