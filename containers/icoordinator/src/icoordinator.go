package main

import "github.com/gin-gonic/gin"
import "net/http"

func main() {
    r := gin.Default()
    r.GET("/icoordinator", func(c *gin.Context) {
      c.Redirect(http.StatusMovedPermanently, "https://apps.icoordinator.com/")
    })
    r.Run()
}
