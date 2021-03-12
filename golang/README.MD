### 实例代码
```
package main

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

func statusOKHandler(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{"status": "success"})
}

func versionHandler(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{"version": "v1.0"})
}

func rootHandler(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{"hello": "world"})
}


func main() {
	router := gin.New()
	router.Use(gin.Recovery())
    router.GET("/", rootHandler)
	router.GET("/ping", statusOKHandler)
	router.GET("/version", versionHandler)
	router.Run(":8080")
}
```
### 打包镜像(建议打包镜像),或者采取此deployment.yml的做法,挂载程序文件
```
Dockerfile

FROM alpine
ADD k8s-demo /data/app/
WORKDIR /data/app/
CMD ["/bin/bash","-c","./k8s-demo"]
```
