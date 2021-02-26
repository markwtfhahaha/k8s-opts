生成配置并且拷贝到容器目录

docker volume create --name $OVPN_DATA
docker run -v $OVPN_DATA:/etc/openvpn --rm kylemanna/openvpn ovpn_genconfig -u udp://VPN.SERVERNAME.COM
docker run -v $OVPN_DATA:/etc/openvpn --rm -it kylemanna/openvpn ovpn_initpki

运行容器,可以吧容器运行在docker-compose.yml或者k8s
docker run -v $OVPN_DATA:/etc/openvpn -d -p 1194:1194/udp --cap-add=NET_ADMIN kylemanna/openvpn

生成用户
docker run -v /home/gluster-data/openvpn/:/etc/openvpn --rm -it kylemanna/openvpn easyrsa build-client-full mark-k8s nopass

获取ovpn文件
docker run -v /home/gluster-data/openvpn/:/etc/openvpn --rm kylemanna/openvpn ovpn_getclient mark-k8s > mark-k8s.ovpn

### 配置文件实例
```
server 192.168.255.0 255.255.255.0
verb 3
key /etc/openvpn/pki/private/si-dev.clubs999.com.key
ca /etc/openvpn/pki/ca.crt
cert /etc/openvpn/pki/issued/si-dev.clubs999.com.crt
dh /etc/openvpn/pki/dh.pem
tls-auth /etc/openvpn/pki/ta.key
key-direction 0
keepalive 10 60
persist-key
persist-tun

proto udp
# Rely on Docker to do port mapping, internally always 1194
port 1194
dev tun0
status /tmp/openvpn-status.log

user nobody
group nogroup
comp-lzo no

### Route Configurations Below
#route 192.168.254.0 255.255.255.0

### Push Configurations Below
push "route 10.96.0.0 255.240.0.0"
push "route 10.244.0.0 255.255.0.0"
push "block-outside-dns"
push "dhcp-option DNS 10.96.0.10"
push "comp-lzo no"
```
### 客户端配置ovpn文件修改
```
#redirect-gateway def1
#注释掉这一行，保证客户端拨号后不使用openvpn网络上网，仅仅只是访问到k8s的内网: 10.96.0.0/12,10.244.0.0/16
```
