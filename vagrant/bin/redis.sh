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

# Set global IP listening
sed -i "s/^bind.*127.0.0.1/bind 0.0.0.0/" /etc/redis.conf

# Install Redis
yum -y install redis
systemctl enable redis
systemctl start redis

if ! redis-cli -h 192.168.12.1 ping >/dev/null 2>&1
then
	echo "Redis is not working as expected" 1>&2
	exit 1
fi
