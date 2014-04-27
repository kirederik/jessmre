package br.inf.ufpr.jessmre

import org.scalatra._
import scalate.ScalateSupport

class RepairServlet extends RepairMreSystemStack {

  get("/") {
    contentType = "text/html"
    val path = "/index.html"
    new java.io.File(getServletContext().getResource(path).getFile)
  }
  
}

