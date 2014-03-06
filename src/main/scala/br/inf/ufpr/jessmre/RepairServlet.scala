package br.inf.ufpr.jessmre

import org.scalatra._
import scalate.ScalateSupport

class RepairServlet extends RepairMreSystemStack {

  get("/") {
    <html>
      <body>
        <h1>Hello, world!</h1>
        Say <a href="hello-scalate">hello to Scalate</a>.
      </body>
    </html>
  }
  
}
