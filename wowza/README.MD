由于wowza官方镜像没有持久化数据，所以需要进到容器将/usr/local/WowzaStreamingEngine-4.8.8.01打包拷贝出来，然后挂载外部目录，这样就能持久化相关配置数据  
tar -zcvf WowzaStreamingEngine-4.8.8.01.tar.gz /usr/local/WowzaStreamingEngine-4.8.8.01 #这样可以保证目录权限正常，直接拷贝可能会导致一些权限问题


