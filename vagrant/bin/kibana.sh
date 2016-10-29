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

# Add the elasticsearch RPM repo
if [[ ! -e /etc/yum.repos.d/kibana.repo ]]
then
  cat >/etc/yum.repos.d/kibana.repo <<_END_
[kibana-4.4]
name=Kibana repository for 4.4.x packages
baseurl=http://packages.elastic.co/kibana/4.4/centos
gpgcheck=1
gpgkey=http://packages.elastic.co/GPG-KEY-elasticsearch
enabled=1
_END_
fi

# Install Logstash Forwarders
yum -y install kibana

# Set Elasticsearch server location
if ! grep '^# elasticsearch.url: "http://localhost:9200"' /opt/kibana/config/kibana.yml | grep -v grep >/dev/null 2>&1
then
  sed -i 's,# elasticsearch.url: "http://localhost:9200",elasticsearch.url: "http://192.168.12.3:9200",' /opt/kibana/config/kibana.yml
fi

# Enable logstash and start it
systemctl enable kibana
systemctl start kibana
