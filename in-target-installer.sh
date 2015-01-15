#!/bin/bash
wget -O /tmp/facter_2.7.3-1puppetlabs1_amd64.deb http://apt.puppetlabs.com/pool/precise/main/f/facter/facter_1.7.3-1puppetlabs1_amd64.deb
wget -O /tmp/puppet-common_2.7.23-1puppetlabs1_all.deb http://apt.puppetlabs.com/pool/precise/main/p/puppet/puppet-common_2.7.23-1puppetlabs1_all.deb
wget -O /tmp/puppet_2.7.23-1puppetlabs1_all.deb http://apt.puppetlabs.com/pool/precise/main/p/puppet/puppet_2.7.23-1puppetlabs1_all.deb
dpkg -i /tmp/facter_1.7.3-1puppetlabs1_amd64.deb
dpkg -i /tmp/puppet-common_2.7.23-1puppetlabs1_all.deb
dpkg -i /tmp/puppet_2.7.23-1puppetlabs1_all.deb
mkdir /root/.ssh
chmod 700 /root/.ssh
wget -O /root/.ssh/authorized_keys https://raw.githubusercontent.com/ctavan/hetzner-bootstrap/basenode/root-ssh-authorizedkeys.pub
/usr/bin/passwd -l root
