# Copyright (c) 2021 Oracle and/or its affiliates.
# All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl
# redisconfig.tf
#
# Purpose: The following script remotely executes all the setup scripts on the Redis compute instances

data "template_file" "install_redis_binaries_sh" {
  template = file("${path.module}/scripts/install_redis_binaries.sh")

  vars = {
    redis_version = var.redis_version
  }
}

data "template_file" "redis_setup_master_sh" {
  depends_on = [oci_core_instance.redis_master]
  template   = file("${path.module}/scripts/redis_setup_master.sh")

  vars = {
    redis_master_ip = oci_core_instance.redis_master.private_ip
  }
}

data "template_file" "redis_setup_replicas_sh" {
  depends_on = [oci_core_instance.redis_replica]
  count      = var.redis_replica_count
  template   = file("${path.module}/scripts/redis_setup_replicas.sh")

  vars = {
    redis_master_ip  = oci_core_instance.redis_master.private_ip
    redis_replica_ip = oci_core_instance.redis_replica[count.index].private_ip
  }
}

resource "null_resource" "master_install_redis_binaries" {
  depends_on = [oci_core_instance.redis_master,
    null_resource.provisioning_disk_redis_master,
    null_resource.partition_disk_redis_master,
    null_resource.pvcreate_exec_redis_master,
    null_resource.vgcreate_exec_redis_master,
    null_resource.format_disk_exec_redis_master,
    null_resource.mount_disk_exec_redis_master
  ]

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = oci_core_instance.redis_master.private_ip
      private_key = file(var.ssh_private_key)
    }

    inline = [
      "sudo rm -rf ~/install_redis_binaries.sh"
    ]
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = oci_core_instance.redis_master.private_ip
      private_key = file(var.ssh_private_key)
    }

    content     = data.template_file.install_redis_binaries_sh.rendered
    destination = "~/install_redis_binaries.sh"
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = oci_core_instance.redis_master.private_ip
      private_key = file(var.ssh_private_key)
    }

    inline = [
      "chmod +x ~/install_redis_binaries.sh",
      "sudo ~/install_redis_binaries.sh"
    ]
  }
}


resource "null_resource" "replica_install_redis_binaries" {
  count = var.redis_replica_count
  depends_on = [oci_core_instance.redis_replica,
    null_resource.provisioning_disk_redis_replica,
    null_resource.partition_disk_redis_replica,
    null_resource.pvcreate_exec_redis_replica,
    null_resource.vgcreate_exec_redis_replica,
    null_resource.format_disk_exec_redis_replica,
    null_resource.mount_disk_exec_redis_replica
  ]

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = oci_core_instance.redis_replica[count.index].private_ip
      private_key = file(var.ssh_private_key)
    }

    inline = [
      "sudo rm -rf ~/install_redis_binaries.sh"
    ]
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = oci_core_instance.redis_replica[count.index].private_ip
      private_key = file(var.ssh_private_key)
    }

    content     = data.template_file.install_redis_binaries_sh.rendered
    destination = "~/install_redis_binaries.sh"
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = oci_core_instance.redis_replica[count.index].private_ip
      private_key = file(var.ssh_private_key)
    }

    inline = [
      "chmod +x ~/install_redis_binaries.sh",
      "sudo ~/install_redis_binaries.sh"
    ]
  }
}




resource "null_resource" "redis_setup_master" {
  depends_on = [null_resource.master_install_redis_binaries]

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = oci_core_instance.redis_master.private_ip
      private_key = file(var.ssh_private_key)
    }

    inline = [
      "sudo rm -rf ~/redis_setup_master.sh"
    ]
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = oci_core_instance.redis_master.private_ip
      private_key = file(var.ssh_private_key)
    }

    content     = data.template_file.redis_setup_master_sh.rendered
    destination = "~/redis_setup_master.sh"
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = oci_core_instance.redis_master.private_ip
      private_key = file(var.ssh_private_key)
    }

    inline = [
      "chmod +x ~/redis_setup_master.sh",
      "sudo ~/redis_setup_master.sh"
    ]
  }
}


resource "null_resource" "redis_setup_replicas" {
  count = var.redis_replica_count
  depends_on = [null_resource.redis_setup_master,
    null_resource.replica_install_redis_binaries
  ]

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = oci_core_instance.redis_replica[count.index].private_ip
      private_key = file(var.ssh_private_key)
    }

    inline = [
      "sudo rm -rf ~/redis_setup_replicas.sh"
    ]
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = oci_core_instance.redis_replica[count.index].private_ip
      private_key = file(var.ssh_private_key)
    }

    content     = data.template_file.redis_setup_replicas_sh[count.index].rendered
    destination = "~/redis_setup_replicas.sh"
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = oci_core_instance.redis_replica[count.index].private_ip
      private_key = file(var.ssh_private_key)
    }

    inline = [
      "chmod +x ~/redis_setup_replicas.sh",
      "sudo ~/redis_setup_replicas.sh"
    ]
  }
}


resource "null_resource" "sentinel_setup_master" {
  depends_on = [null_resource.redis_setup_master,
    null_resource.redis_setup_replicas
  ]

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = oci_core_instance.redis_master.private_ip
      private_key = file(var.ssh_private_key)
    }

    inline = [
      "sudo rm -rf ~/sentinel_setup.sh"
    ]
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = oci_core_instance.redis_master.private_ip
      private_key = file(var.ssh_private_key)
    }

    source      = "${path.module}/sentinel_setup.sh"
    destination = "~/sentinel_setup.sh"
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = oci_core_instance.redis_master.private_ip
      private_key = file(var.ssh_private_key)
    }

    inline = [
      "chmod +x ~/sentinel_setup.sh",
      "sudo ~/sentinel_setup.sh ${oci_core_instance.redis_master.private_ip} ${tonumber(var.redis_replica_count)}"
    ]
  }
}


resource "null_resource" "sentinel_setup_replicas" {
  count = var.redis_replica_count
  depends_on = [null_resource.redis_setup_master,
    null_resource.redis_setup_replicas
  ]

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = oci_core_instance.redis_replica[count.index].private_ip
      private_key = file(var.ssh_private_key)
    }

    inline = [
      "sudo rm -rf ~/sentinel_setup.sh"
    ]
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = oci_core_instance.redis_replica[count.index].private_ip
      private_key = file(var.ssh_private_key)
    }

    source      = "${path.module}/sentinel_setup.sh"
    destination = "~/sentinel_setup.sh"
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "opc"
      host        = oci_core_instance.redis_replica[count.index].private_ip
      private_key = file(var.ssh_private_key)
    }

    inline = [
      "chmod +x ~/sentinel_setup.sh",
      "sudo ~/sentinel_setup.sh ${oci_core_instance.redis_master.private_ip} ${tonumber(var.redis_replica_count)}"
    ]
  }
}

