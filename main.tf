resource "proxmox_vm_qemu" "cloudinit-test" {
  name = "VM-terraform"

  target_node = var.pm_node
  clone       = var.pm_clone


  agent    = 1
  os_type  = "cloud-init"
  cores    = 2
  sockets  = 1
  vcpus    = 0
  cpu      = "host"
  scsihw   = "virtio-scsi-pci"
  bootdisk = "scsi0"


  disk {
    slot    = 0
    size    = "30G"
    type    = "scsi"
    storage = "local-lvm"
  }

  # Setup the network interface and assign a vlan tag: 256
  network {
    model  = "virtio"
    bridge = "vmbr0"
    tag    = 256
  }

  # Setup the ip address using cloud-init.
  boot = "order=virtio0"
  # Keep in mind to use the CIDR notation for the ip.
  ipconfig0 = "ip=192.168.10.20/24,gw=192.168.10.1"

}
