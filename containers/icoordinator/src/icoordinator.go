package main

import "github.com/gin-gonic/gin"
import "net/http"

func main() {
	r := gin.Default()
	r.LoadHTMLGlob("/go/tmpl/*")
	r.Static("/icoordinator/assets", "/go/assets")
	r.GET("/icoordinator", func(c *gin.Context) {
		c.HTML(http.StatusOK, "index.tmpl", gin.H{
			"title": "Main website",
		})
	})
	//		c.Redirect(http.StatusTemporaryRedirect, "https://apps.icoordinator.com/")
	r.Run(":80")
}
