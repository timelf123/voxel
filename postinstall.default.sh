#!/bin/bash -eu

# Install puppet.
wget -O /tmp/facter_1.7.3-1puppetlabs1_amd64.deb http://apt.puppetlabs.com/pool/precise/main/f/facter/facter_1.7.3-1puppetlabs1_amd64.deb
wget -O /tmp/puppet-common_2.7.26-1puppetlabs1_all.deb http://apt.puppetlabs.com/pool/precise/main/p/puppet/puppet-common_2.7.26-1puppetlabs1_all.deb
wget -O /tmp/puppet_2.7.26-1puppetlabs1_all.deb http://apt.puppetlabs.com/pool/precise/main/p/puppet/puppet_2.7.26-1puppetlabs1_all.deb
wget -O /tmp/hiera_1.3.4-1puppetlabs1_all.deb http://apt.puppetlabs.com/pool/precise/main/h/hiera/hiera_1.3.4-1puppetlabs1_all.deb
wget -O /tmp/hiera-puppet_1.0.0-1puppetlabs1_all.deb http://apt.puppetlabs.com/pool/precise/main/h/hiera-puppet/hiera-puppet_1.0.0-1puppetlabs1_all.deb

dpkg -i /tmp/facter_1.7.3-1puppetlabs1_amd64.deb
dpkg -i /tmp/puppet-common_2.7.26-1puppetlabs1_all.deb
dpkg -i /tmp/puppet_2.7.26-1puppetlabs1_all.deb
dpkg -i /tmp/hiera_1.3.4-1puppetlabs1_all.deb
dpkg -i /tmp/hiera-puppet_1.0.0-1puppetlabs1_all.deb

rm -rf /tmp/*.deb

sed -i '/templatedir/a pluginsync=true' /etc/puppet/puppet.conf

# Install passwordless access.
ROOT_USERS=(
    leitmedium
    ctavan
    dohse
    0x7f
    mren
    eckardt
    mwm42
)
mkdir -p /root/.ssh
chown root: /root/.ssh
chmod 700 /root/.ssh
for USER in "${ROOT_USERS[@]}"
do
    MAIL_ADDRESS=$(wget -qO - https://api.github.com/users/$USER | awk -F'"' '/"email": /{print $4}')
    wget -qO - https://api.github.com/users/$USER/keys |
        awk -v user="$MAIL_ADDRESS - github user $USER" -F'"' '/"key": /{print $4, user}' >> /root/.ssh/authorized_keys
done
chmod 600 /root/.ssh/authorized_keys

/usr/bin/passwd -l root
