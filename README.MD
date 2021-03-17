k8s应用部署
```
1. 网络存储使用gluster fs  
2. 健康检查  
          startupProbe:
            tcpSocket:
                port: 80
            failureThreshold: 30
            periodSeconds: 10
          readinessProbe:
            tcpSocket:
                port: 80
            initialDelaySeconds: 5
            periodSeconds: 10
          livenessProbe:
            tcpSocket:
                port: 80
            initialDelaySeconds: 15
            periodSeconds: 20
```


