#!/bin/bash -eu

# Install puppet.
HIERA_VERSION=1.3.4-1puppetlabs1
PUPPET_VERSION=3.7.5-1puppetlabs1
FACTER_VERSION=2.4.3-1puppetlabs1
wget -O /tmp/hiera_${HIERA_VERSION}_all.deb http://apt.puppetlabs.com/pool/precise/main/h/hiera/hiera_${HIERA_VERSION}_all.deb
wget -O /tmp/facter_${FACTER_VERSION}_all.deb http://apt.puppetlabs.com/pool/precise/main/f/facter/facter_${FACTER_VERSION}_all.deb
wget -O /tmp/puppet-common_${PUPPET_VERSION}_all.deb http://apt.puppetlabs.com/pool/precise/main/p/puppet/puppet-common_${PUPPET_VERSION}_all.deb
wget -O /tmp/puppet_${PUPPET_VERSION}_all.deb http://apt.puppetlabs.com/pool/precise/main/p/puppet/puppet_${PUPPET_VERSION}_all.deb

dpkg -i /tmp/hiera_${HIERA_VERSION}_all.deb
dpkg -i /tmp/facter_${FACTER_VERSION}_all.deb
dpkg -i /tmp/puppet-common_${PUPPET_VERSION}_all.deb
dpkg -i /tmp/puppet_${PUPPET_VERSION}_all.deb

rm -rf /tmp/*.deb

apt-get -y update
apt-get -y install --install-recommends linux-generic-lts-trusty

sed -i '/templatedir/a pluginsync=true' /etc/puppet/puppet.conf

# Set puppet-private hostname to public IP until private interface is
# configured.
echo '64.95.99.203 puppet-private.m6r.eu' >> /etc/hosts

# Fix the order of the network interfaces by the order of mac addresses.
UDEV_RULES=/etc/udev/rules.d/70-persistent-net.rules
INDEX=0
while read MAC
do
    DEV="eth$INDEX"
    echo "Fixing network interface $MAC to $DEV"
    sed -i "/$MAC/s/eth[0-9]/$DEV/g" $UDEV_RULES
    ((INDEX+=1))
done < <( grep -Po 'ATTR\{address\}==\"\K[0-9a-f:]+' $UDEV_RULES | sort )
sed -i 's/eth1/eth0/g' /etc/network/interfaces

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
