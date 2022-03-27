# Section 2. Linux 作为网络节点和问题解决平台

本部分内容:
- Linux host
- 网络诊断和解决
- 防火墙
- 安全
- 方法、监管框架、强化指南、框架

# Chapter 3 Using Linux and Linux Tools for Network Diagnostics

本章会讲解一些如何工作的网络基础。
- OSI
- 第2层, 使用ARP连接IP地址和MAC，以及一些详细的MAC数据
- 第4层, TCP-UDP 的端口是如何工作的, TCP的三次握手, 和如何在Linux里出现的
- 本地TCP和UDP端口枚举, 和运行服务的关系
- 使用两种本地端口实现远程枚举

# 常见工具的总结
|对象|功能描述|
|---|---|
|arp|关联物理MAC地址和IP地址|
|netplan|基于Yaml的网络设置配置工具|
|ip and ifconfig|展示本地主机的网络接口的参数|
|netstat and ss|查看本地主机额度TCP/UDP监听端口, 以及关联的进程. 也可以用来观察TCP的状态变化|
|telnet|非常不好的工具|
|nc(Netcat)|在远程服务上，常被用来连接和细查. 也可以测试本机上的本机服务|
|Nmap|枚举和测试远程主机的监听端口,也可以对这些端口执行脚本|
|Kismet|查看未连接的无线网络详情|
|Wavemon|查看已连接的无线网络详情, 尤其是在信号增强和性能相关上|
|LinSSID|Kismet的图形化工具，擅长挖掘在周围无线网络中的信号强度和信道利用率|

# ARP
- ARP请求会在每个主机上储存缓存。缓存区叫做ARP cahce / ARP table。
- `arp -a`
- 查看`arp`的过时时间: `cat /proc/sys//net/ipv4/neigh/default/gc_stale_time`
- 修改`mac ip`: `arp -s 192.168.122.200 00:11:22:22:33:33`
- 删除: `arp -i ens33 -d 192.168.122.200`
- 伪装成给定的ip地址, 比如10.0.0.1的ARP应答: `sudo arp -i eth0 -Ds 10.0.0.2 eth1 pub`

- 查找MAC地址的四种办法：
    - ip link show | grep link
    - ifconfig
- 设置：
```shell
$ sudo ip link set dev ens33 down
$ sudo ip link set dev ens33 address 00:88:77:66:55:44
$ sudo ip link set dev ens33 device here> up
```
# TCP/UDP端口工作
|名字|端口|
|---|---|
|DNS| udp/53, tcp/53|
|Telnet|tcp/23|
|SSH|tcp/22|
|FTP|tcp/20 and tcp/21|
|HTTP|tcp/80|
|HTTPS|tcp/443|
|SNMP|udp/162|
|Syslog|tcp/443|

## 监听端口变化
netstat是个常用的传统工具，可以获取网络变化的状态。以下为常用的参数:
- t: TCP ports
- u: UDP ports
- a: 所有端口，包含监听和没有监听在内
- n: 不对指定的ip进行解析。如果为空，则解析列表中的每个ip

- `netstat -tuan`
