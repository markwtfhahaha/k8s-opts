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
