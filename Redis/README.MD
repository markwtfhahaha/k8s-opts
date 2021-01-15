redis-cluster  
service和deployment部署好之后  
redis-cli --cluster create 10.96.130.220:7070 10.96.130.220:7071 10.96.130.220:7072 10.96.130.220:7073 10.96.130.220:7074 10.96.130.220:7075 --cluster-replicas 1 --cluster-yes -a 123456  


