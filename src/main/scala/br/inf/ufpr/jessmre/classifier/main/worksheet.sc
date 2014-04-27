package br.inf.ufpr.jessmre.classifier.main

object worksheet{
  val b = Map("dominio" -> "2")                   //> b  : scala.collection.immutable.Map[String,String] = Map(dominio -> 2)
  
  b.get("dominio").get                            //> res0: String = 2
}