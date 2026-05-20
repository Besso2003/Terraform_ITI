resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/templates/inventory.tpl", {
    bastion_ip = aws_instance.bastion.public_ip
    app_ip     = aws_instance.app.private_ip
  })
  filename        = "${path.module}/../Ansible/inventory.ini"
  file_permission = "0644"
}

resource "local_file" "ssh_config" {
  content = templatefile("${path.module}/templates/ssh_cfg.tpl", {
    bastion_ip = aws_instance.bastion.public_ip
  })
  filename        = "${path.module}/../Ansible/ssh.cfg"
  file_permission = "0600"
}