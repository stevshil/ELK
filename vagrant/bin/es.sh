#!/bin/bash
# This configuration is based on a cluster
# https://www.digitalocean.com/community/tutorials/how-to-set-up-a-production-elasticsearch-cluster-on-ubuntu-14-04

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

# Add the elasticsearch RPM repo
if [[ ! -e /etc/yum.repos.d/elasticsearc.repo ]]
then
  cat >/etc/yum.repos.d/elasticsearch.repo <<_END_
[elasticsearch-2.x]
name=Elasticsearch repository for 2.x packages
baseurl=http://packages.elastic.co/elasticsearch/2.x/centos
gpgcheck=1
gpgkey=http://packages.elastic.co/GPG-KEY-elasticsearch
enabled=1
_END_
fi

# Install Logstash Forwarders
yum -y install elasticsearch

# Configure listening addresses
if ip a | grep '192\.168\.12\.3' >/dev/null 2>&1
then
	sed -i "s/# network.host: 192.168.0.1/network.host: 192.168.12.3/" /etc/elasticsearch/elasticsearch.yml
fi

if ip a | grep '192\.168\.12\.6' >/dev/null 2>&1
then
	sed -i "s/# network.host: 192.168.0.1/network.host: 192.168.12.6/" /etc/elasticsearch/elasticsearch.yml
fi

# Set the nodes in the cluster
sed -i 's/.*discovery.zen.ping.unicast.hosts.*/discovery.zen.ping.unicast.hosts: ["192.168.12.3","192.168.12.6"]/' /etc/elasticsearch/elasticsearch.yml
sed -i 's/.*node.name:.*/node.name: ${HOSTNAME}' /etc/elasticsearch/elasticsearch.yml
sed -i -e 's/.*bootstrap.mlockall.*/bootstrap.mlockall: true/' -e 's/.*discovery.zen.minimum_master_nodes:.*/discovery.zen.minimum_master_nodes: 2/' /etc/elasticsearch/elasticsearch.yml
sed -i  -e 's/.*ES_HEAP_SIZE.*/ES_HEAP_SIZE=512m/' -e 's/.*MAX_LOCKED_MEMORY.*/MAX_LOCKED_MEMORY=unlimited/' /etc/default/elasticsearch

# Enable logstash and start it
systemctl enable elasticsearch
systemctl start elasticsearch
