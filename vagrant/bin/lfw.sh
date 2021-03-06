#!/bin/bash

# Disable selinux
sed -i 's/^SELINUX=permissive/SELINUX=disabled/' /etc/sysconfig/selinux
setenforce 0

# Check system is up to date first
yum update

# Install RPM fusion repo
if ! ls /etc/yum.repos.d/*rpmfusion* >/dev/null 2>&1
then
	yum -y install https://download1.rpmfusion.org/free/el/updates/6/i386/rpmfusion-free-release-6-1.noarch.rpm
	yum -y install https://download1.rpmfusion.org/nonfree/el/updates/6/i386/rpmfusion-nonfree-release-6-1.noarch.rpm
fi

# Install Java
if ! rpm -qa | grep java-1.8.0-openjdk | grep -v grep >/dev/null 2>&1
then
  yum -y install java-1.8.0-openjdk
fi

# Add the logstash RPM repo
if [[ ! -e /etc/yum.repos.d/logstash.repo ]]
then
  cat >/etc/yum.repos.d/logstash.repo <<_END_
[logstash-2.2]
name=logstash repository for 2.2 packages
baseurl=http://packages.elasticsearch.org/logstash/2.2/centos
gpgcheck=1
gpgkey=http://packages.elasticsearch.org/GPG-KEY-elasticsearch
enabled=1
_END_
fi

# Install Logstash Forwarders
yum -y install logstash

# Set the logstash user as root, to enable reading of logs
if grep '^#LS_USER=' /etc/sysconfig/logstash >/dev/null 2>&1
then
  sed -i 's/.*LS_USER=.*/LS_USER=root/' /etc/sysconfig/logstash
fi

# Configure logstash
if [[ ! -e /etc/logstash/conf.d/01-toredis.conf ]]
then
  cat >/etc/logstash/conf.d/01-toredis.conf <<_END_
input {
  file { path => '/var/log/messages' }
}
output {
	stdout {}
  redis { host => "192.168.12.1" data_type => "list" key => "logstash" }
}
_END_
fi

# Enable logstash and start it
systemctl enable logstash
systemctl start logstash
