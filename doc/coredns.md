# CoreDNS

## 1. CoreDNS 简介

CoreDNS服务器利用SkyDNS的库来为Kubernetes pod和服务提供DNS请求。
SkyDNS2的作者，Miek Gieben，创建了一个新的DNS服务器，CoreDNS，它采用更模块化，可扩展的框架构建。 


CoreDNS利用作为Web服务器Caddy的一部分而开发的服务器框架。
该框架具有非常灵活，可扩展的模型，用于通过各种中间件组件传递请求。
这些中间件组件根据请求提供不同的操作，例如记录，重定向，修改或维护。
虽然它一开始作为Web服务器，但是Caddy并不是专门针对HTTP协议的，而是构建了一个基于CoreDNS的理想框架。

在这种灵活的模型中添加对Kubernetes的支持，相当于创建了一个Kubernetes中间件。
该中间件使用Kubernetes API来满足针对特定Kubernetes pod或服务的DNS请求。
而且由于Kube-DNS作为Kubernetes的另一项服务，kubelet和Kube-DNS之间没有紧密的绑定。
您只需要将DNS服务的IP地址和域名传递给kubelet，而Kubernetes并不关心谁在实际处理该IP请求。


## 2. CoreDNS支持行为

- A记录（正常的Service分配了一个名为my-svc.my-namespace.svc.cluster.local的DNS A记录。 这解决了服务的集群IP）
- “headless”（没有集群IP）的Service也分配了一个名为my-svc.my-namespace.svc.cluster.local的DNS A记录。 与普通服务不同，这解决了Service选择了pods的一组IP。 客户预计将从这ip集合中消耗集合或使用标准循环选择。
- 针对名为正常或无头服务的端口创建的SRV记录，对于每个命名的端口，SRV记录的格式为_my-port-name._my-port-protocol.my-svc.my-namespace.svc.cluster.local。对于常规服务，这将解析为端口号和CNAME：my-svc.my-namespace.svc.cluster.local；对于无头服务，这解决了多个答案，一个用于支持服务的每个pod，并包含端口号还有格式为auto-generated-name.my-svc.my-namespace.svc.cluster.local 的pod的CNAME 。SRV记录包含它们中的“svc”段，对于省略“svc”段的旧式CNAME不支持。
- 作为Service一部分的endpoints的A记录（比如“pets”的记录）
- pod的Spec中描述的A记录
- 还有就是用来发现正在使用的DNS模式版本的TXT记录

## 3. 安装

参考安装文件: https://github.com/wongoo/k8s-manual-files/blob/master/install/6-addon/6-2-addon-coredns.sh

## 4. 配置文件

参考 coredns manifest文件:  https://github.com/wongoo/k8s-manual-files/blob/master/addons/coredns/1.2.5/coredns.yaml

```
apiVersion: v1
kind: ConfigMap
metadata:
  name: coredns
  namespace: kube-system
data:
  Corefile: |
    .:53 {
        errors
        health
        kubernetes cluster.local in-addr.arpa ip6.arpa {
          pods insecure
          upstream
          fallthrough in-addr.arpa ip6.arpa
        }
        prometheus :9153
        proxy . /etc/resolv.conf
        cache 30
        loop
        reload
        loadbalance
    }
```

### errors
Any errors encountered during the query processing will be printed to standard output. 
参考 https://coredns.io/plugins/errors/
	
### health
健康检查，提供了指定端口（默认为8080）上的HTTP端点，如果实例是健康的，则返回“OK”。
参考:https://coredns.io/plugins/health/	

### kubernetes
对[Kubernetes DNS-Based Service Discovery](https://github.com/kubernetes/dns/blob/master/docs/specification.md)的实现。
CoreDNS running the kubernetes plugin can be used as a replacement of kube-dns in a kubernetes cluster. 
参考:https://coredns.io/plugins/kubernetes/

- `cluster.local`: 指定k8s cluster的域
- `in-addr.arpa`: 声明ipv4 DNS反向解析支持,如`0.0.3.10.in-addr.arpa`
- `ip6.arpa`: 声明ipv6 DNS反向解析支持,如`8.b.d.0.1.0.0.2.ip6.arpa`

The reverse DNS database of the Internet works with a hierarchical tree of servers, just like forward DNS. It is rooted in the Address and Routing Parameter Area (arpa) top-level domain of the Internet. One level below the arpa root are the delegated servers in-addr.arpa for IPv4 and ip6.arpa for IPv6.
The process of reverse resolving an IP address uses the pointer DNS record type (PTR record).
![](https://www.ripe.net/manage-ips-and-asns/db/support/forwardreversedns.png)

- `pods insecure`: Always return an A record with IP from request (without checking k8s)
- `upstream [ADDRESS…]`: defines the upstream resolvers used for resolving services that point to external hosts (aka External Services aka CNAMEs).
- fallthrough [ZONES…]: If a query for a record in the zones for which the plugin is authoritative results in NXDOMAIN, normally that is what the response will be. However, if you specify this option, the query will instead be passed on down the plugin chain, which can include another plugin to handle the query.

### prometheus
With prometheus you export metrics from CoreDNS and any plugin that has them. The metrics path is fixed to /metrics.
参考: https://coredns.io/plugins/metrics/


### proxy
syntax: `proxy FROM TO`
- `FROM` is the name to match for the request to be proxied.
- `TO` is the destination endpoint to proxy to. At least one is required, but multiple may be specified. TO may be an IP:Port pair, or may reference a file in resolv.conf format

这可以配置多个upstream 域名服务器，也可以用于延迟查找 /etc/resolv.conf 中定义的域名服务器.
参考: https://coredns.io/plugins/proxy/

### cache

这允许缓存两个响应结果，一个是肯定结果（即，查询返回一个结果）和否定结果（查询返回“没有这样的域”），具有单独的高速缓存大小和TTLs。
参考: https://coredns.io/plugins/cache/

### loop
The loop plugin will send a random probe query to ourselves and will then keep track of how many times we see it. 
If we see it more than twice, we assume CoreDNS is looping and we halt the process.

参考: https://coredns.io/plugins/loop/

### reload
allows automatic reload of a changed Corefile.
参考: https://coredns.io/plugins/reload/

### loadbalance
The loadbalance will act as a round-robin DNS loadbalancer by randomizing the order of A, AAAA, and MX records in the answer.
参考: https://coredns.io/plugins/loadbalance/


## 9. 参考

- CoreDNS Manual, https://coredns.io/manual/toc/
- kubernetes上的服务发现-CoreDNS配置, https://my.oschina.net/u/2306127/blog/1788566
 
