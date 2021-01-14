根据需求修改几个文件，命名空间等，多从可以继续添加，但是注意数据目录要区分开来
持久化数据使用网络存储gluster fs，也可以采用其他的，比如，nfs，建议使用gluster fs

pod运行起来之后，利用service互相通信建立主从
mysql-0-service:3306 主
mysql-1-service:3306 从
mysql-2-service:3306 从

1. 分别执行
主 
CREATE USER 'admin'@'%' IDENTIFIED BY 'adminpass'; 
GRANT REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO 'admin'@'%';
show master status; #查询相关信息

利用master status信息制作如下命令并且执行
备 
change master to master_host='mysql-0-service', master_user='admin', master_password='adminpass', master_port=3306, master_log_file='mysql-bin.000005', master_log_pos=617, master_connect_retry=30; 
start slave; 
show slave status \G;

2. 验证
CREATE DATABASE `test` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci; #主
show databases; #从

