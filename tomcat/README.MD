### 相关环境变量

```
TOMCAT_SHUTDOWN_PORT_NUMBER: Tomcat shutdown port. Default: 8005
TOMCAT_HTTP_PORT_NUMBER: Tomcat HTTP port. Default: 8080
TOMCAT_AJP_PORT_NUMBER: Tomcat AJP port. Default: 8009
TOMCAT_HOME: Tomcat user's home directory, this will set user.home. Default: /opt/bitnami/tomcat
TOMCAT_USERNAME: Tomcat user. Default: user
TOMCAT_PASSWORD: Tomcat password.
TOMCAT_ALLOW_REMOTE_MANAGEMENT: Allow to connect to manager applications from remote addresses. Valid values are 0 and 1. Default: 0
JAVA_HOME: Java home directory.
JAVA_OPTS: Tomcat java settings. Default: -Djava.awt.headless=true -XX:+UseG1GC -Dfile.encoding=UTF-8 -Duser.home=$TOMCAT_HOME
```


