## k8s应用部署
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
3. 资源限制
          resources:
            requests:
              memory: "1024Mi"
              cpu: "1000m"
            limits:
              memory: "2048Mi"
              cpu: "2000m"
4. 使用动态卷(storageClass,StatefulSet)
  volumeClaimTemplates:
  - metadata:
      name: data
      annotations:
        volume.beta.kubernetes.io/storage-class: longhorn-shared-sc
    spec:
      accessModes: ["ReadWriteOnce"] #ReadWriteMany
      resources:
        requests:
          storage: 10Gi

5. 使用pvc(storageClass,Deployment)
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: longhorn-shared-pvc
  namespace: mark-k8s-dev
spec:
  accessModes:
    - ReadWriteOnce
    #- ReadWriteMany #需要的时候可给多容器挂载
  storageClassName: longhorn-shared-sc
  resources:
    requests:
      storage: 10Gi


```



