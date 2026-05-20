resource "null_resource" "create_ansible_dir" {
  provisioner "local-exec" {
    command = "mkdir -p ${path.module}/../Ansible"
  }
}

resource "local_file" "ansible_inventory" {
  depends_on = [null_resource.create_ansible_dir]

  content = templatefile("${path.module}/templates/inventory.tpl", {
    bastion_ip = aws_instance.bastion.public_ip
    app_ip     = aws_instance.app.private_ip
  })

  filename        = "${path.module}/../Ansible/inventory.ini"
  file_permission = "0644"
}

resource "local_file" "ssh_config" {
  depends_on = [null_resource.create_ansible_dir]

  content = templatefile("${path.module}/templates/ssh_cfg.tpl", {
    bastion_ip = aws_instance.bastion.public_ip
  })

  filename        = "${path.module}/../Ansible/ssh.cfg"
  file_permission = "0600"
}