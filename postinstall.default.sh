#!/bin/bash

wget -O /tmp/facter_2.7.3-1puppetlabs1_amd64.deb http://apt.puppetlabs.com/pool/precise/main/f/facter/facter_1.7.3-1puppetlabs1_amd64.deb
wget -O /tmp/puppet-common_2.7.26-1puppetlabs1_all.deb http://apt.puppetlabs.com/pool/precise/main/p/puppet/puppet-common_2.7.26-1puppetlabs1_all.deb
wget -O /tmp/puppet_2.7.26-1puppetlabs1_all.deb http://apt.puppetlabs.com/pool/precise/main/p/puppet/puppet_2.7.26-1puppetlabs1_all.deb
dpkg -i /tmp/facter_1.7.3-1puppetlabs1_amd64.deb
dpkg -i /tmp/puppet-common_2.7.26-1puppetlabs1_all.deb
dpkg -i /tmp/puppet_2.7.26-1puppetlabs1_all.deb
rm -rf /tmp/*.deb

$ROOT_USERS=(
    leitmedium
    ctavan
    dohse
)
mkdir /root/.ssh
chmod 700 /root/.ssh
wget -O /root/.ssh/authorized_keys https://raw.githubusercontent.com/ctavan/hetzner-bootstrap/basenode/root-ssh-authorizedkeys.pub
for USER in "${ROOT_USERS[@]}"
do
    MAIL_ADDRESS=$(wget -qO - https://api.github.com/users/$USER | awk -F'"' '/"email": /{print $4}')
    wget -qO - https://api.github.com/users/$USER/keys |
        awk -v user="$MAIL_ADDRESS - github user $USER" -F'"' '/"key": /{print $4, user}' >> /root/.ssh/authorized_keys
done
chmod 600 /root/.ssh/authorized_keys

/usr/bin/passwd -l root
