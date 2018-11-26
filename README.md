# vacmon
State monitoring service for Vac and Vcycle. This version supports 5.2.0 and 6.x

Install the vacmond RPM and its dependencies (including elasticsearch)

Install the python-pip RPM then

pip install pygal
pip install elasticsearch

echo 'export ES_HEAP_SIZE=20g' >>/etc/sysconfig/elasticsearch

systemctl enable elasticsearch.service
systemctl start elasticsearch.service
systemctl enable httpd.service
systemctl start httpd.service
chkconfig vacmond on
service vacmond restart

vacmond should create its ElasticSearch indexes when it starts. If they need
to be deleted and this repeated, then do 

curl -X DELETE "localhost:9200/machines"  
curl -X DELETE "localhost:9200/machinetypes"  
curl -X DELETE "localhost:9200/factories"  

If you need to create a network alias add one, like:

cat > /etc/sysconfig/network-scripts/ifcfg-eth0:12 <<EOF
DEVICE=eth0:12
IPADDR=195.194.106.249
BOOTPROTO=static
NETMASK=255.255.255.0
TYPE=Ethernet
ONBOOT=yes
EOF

The iptables firewall must allow incoming port UDP 8884.
