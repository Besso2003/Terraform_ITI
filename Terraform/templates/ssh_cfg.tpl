Host bastion
    HostName ${bastion_ip}
    User ec2-user
    IdentityFile ~/.ssh/bastion-key
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null

Host 10.0.*.*
    User ec2-user
    IdentityFile ~/.ssh/bastion-key
    ProxyJump bastion
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null