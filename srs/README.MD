## 默认视频服务器配置,接收rtmp推流，并且转换为http flv
```
listen              1935;
max_connections     10000;
srs_log_tank        console;
daemon              off;
http_api {
    enabled         on;
    listen          1985;
}
http_server {
    enabled         on;
    listen          8080;
    dir             ./objs/nginx/html;
}

vhost __defaultVhost__ {
    tcp_nodelay     on;
    min_latency     on;
    http_remux {
        enabled     on;
    }
}
```

## 作为边缘节点，拉流rtmp，多个以逗号隔开
```
listen              1935;
max_connections     10000;
srs_log_tank        console;
daemon              off;
vhost __defaultVhost__ {
    tcp_nodelay     on;
    min_latency     on;
    cluster {
        mode remote;
        origin 10.10.10.42;
    }
}
```

## 转发流，接收到视频流，无条件转发到其他视频服务器，多个以逗号隔开,rtmp
```
listen              1935;
max_connections     10000;
srs_log_tank        console;
daemon              off;
vhost __defaultVhost__ {
    tcp_nodelay     on;
    min_latency     on;
    forward {
        enabled on;
        destination 43.245.200.167:1935 43.245.200.47:1935;
    }
}
```

## 集群方案，三个pod，两个作为视频服务源端，一个作为边缘，提供访问
```
#边缘，指向server A, server B
listen              1935;
max_connections     10000;
daemon              off;
srs_log_tank        console;
vhost __defaultVhost__ {
    cluster {
        mode            remote;
        origin          serverA.serverA-service.mark-k8s-dev.svc.cluster.local:1935 serverB.serverB-service.mark-k8s-dev.svc.cluster.local:1935;
    }
}
```
```
#server A
listen              1935;
max_connections     10000;
daemon              off;
srs_log_tank        console;
http_api {
    enabled         on;
    listen          9090;
}
vhost __defaultVhost__ {
    cluster {
        mode            local;
        origin_cluster  on;
        coworkers       serverB.serverB-service.mark-k8s-dev.svc.cluster.local:9090;
    }
}
```
```
#server B
listen              1935;
max_connections     10000;
daemon              off;
srs_log_tank        console;
http_api {
    enabled         on;
    listen          9090;
}
vhost __defaultVhost__ {
    cluster {
        mode            local;
        origin_cluster  on;
        coworkers       serverA.serverA-service.mark-k8s-dev.svc.cluster.local:9090;
    }
}
```