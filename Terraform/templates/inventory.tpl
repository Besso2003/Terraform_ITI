[bastion]
${bastion_ip}

[app]
${app_ip}

[app:vars]
ansible_ssh_common_args='-F ./ssh.cfg'