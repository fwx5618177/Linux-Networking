
[TOC]

# 第三部分总结
- DNS
- DHCP
- Certificate
- Radius
- Load Balance
- Packet Capture and Analysis
- Network Monitoring
- 入侵防御
- Honeypot

# DNS
- 2 DNS服务器的建立

## BIND/ DNSmasq - DNS 实现工具
DNS建立工具。

- 安装bind: `sudo apt-get install -y bind9`
- 查看bind的配置文件: `cat /etc/bind/named.conf`
- 查看配置文件: `cat /etc/bind/named.conf.options`

# DHCP server
- 安装: `sudo apt-get install isc-dhcp-server`
- 配置文件位置: `/etc/dhcp/dhcpd.conf`
    - 在配置过程中，尽量避免使用`192.168.0.0/24`/`192.168.1.0/24`
- 新增:
```shell
# Specify the network address and subnet-mask
 subnet 192.168.122.0 netmask 255.255.255.0 {
 # Specify the default gateway address
 option routers 192.168.122.1;
 # Specify the subnet-mask
 option subnet-mask 255.255.255.0;
 # Specify the range of leased IP addresses
 range 192.168.122.10 192.168.122.200;
}
```
- 重启: `sudo systemctl restart isc-dhcp-server.service`
- 查看所有租约: `dhcp-lease-list`
- DHCP日志: `/var/log/dhcpd.log`

# Certificate
CA证书。
- 建立私人证书
- 维护证书基建设施

## 用OpenSSL创建CA
1. 查看`/etc/ssl`目录存在
2. 新建目录:
```shell
sudo mkdir /etc/ssl/CA
sudo mkdir /etc/ssl/newcerts
```
3. 创建临时文件:
```shell
sudo sh -c "echo '01' > /etc/ssl/CA/serial"

sudo touch /etc/ssl/CA/index.txt
```
4. 编辑`/etc/ssl/openssl.cnf`，并且重指向[CA_default]
```shell
[CA_default]
dir = /etc/ssl # Where everything is kept
database = $dir/CA/index.txt # database index file.
certificate = $dir/certs/cacert.pem # The CA certificate
serial = $dir/CA/serial # The current serial number
private_key = $dir/private/cakey.pem # The private key
```
5. 生成私人CA（公共CA，需要创建一个新的CSR，并且加上CA的签名）
```shell
sudo openssl req -new -x509 -extensions v3_ca -keyout cakey.pem -out cacert.pem -days 3650
```
6. 移动证书文件:
```shell
sudo mv cakey.pem /etc/ssl/private
sudo mv cacert.pem /etc/ssl/certs/
```

CA已经做好，现在创建CSR并且签名。

## 签名CSR
1. 创建私钥:`openssl genrsa -des3 -out server.key 2048`
2. 创建安全密钥: `openssl rsa -in server.key -out server.key.insecure`
3. 更换名字:
```shell
mv server.key server.key.secure
mv server.key.insecure server.key
```
4. 创建CSR: `openssl req -new -key server.key -out server.csr`
5. 签名: `sudo openssl ca -in server.csr -config /etc/ssl/openssl.cnf`
6. 生成结果: `ls /etc/ssl/newcerts # 01.pem`




