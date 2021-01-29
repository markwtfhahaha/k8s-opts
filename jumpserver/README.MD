create database jumpserver default charset 'utf8' collate 'utf8_bin';  
grant all on jumpserver.* to 'jumpserver'@'%' identified by 'testpass';  
flush privileges;  
  
  
由于可能不能正常初始化数据库，所以这里准备了data.tar.gz, 直接放到mysql data目录即可,root,jumpserver两个用户的密码为 UzSwp6lVWkufmBwN
